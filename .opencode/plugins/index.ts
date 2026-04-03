// index.ts — OpenCode plugin entry point
//
// Registers tool.execute.before and tool.execute.after hooks to intercept
// file edits and send diff previews to Neovim via RPC.

import type { Plugin } from "@opencode-ai/plugin"
import { writeFileSync, existsSync, unlinkSync, appendFileSync } from "fs"
import { dirname, resolve, relative } from "path"
import { tmpdir } from "os"

import { findNvimSocket, escapeLua, nvimSend } from "./nvim.js"
import { applyEdit, applyMultiEdit, applyOpenAIPatch, applyUnifiedDiff, readFileOrEmpty } from "./edits.js"

// ── Temp file management ──────────────────────────────────────────

const ORIG_FILE = resolve(tmpdir(), "claude-diff-original")
const PROP_FILE = resolve(tmpdir(), "claude-diff-proposed")
const DEBUG_LOG = "/tmp/claude-preview-opencode.log"

function debugLog(message: string): void {
  try { appendFileSync(DEBUG_LOG, `${new Date().toISOString()} ${message}\n`) } catch {}
}

function patchPreview(patchText: string): string {
  const preview = patchText.split(/\r?\n/).slice(0, 5).join("\n")
  return preview.length > 500 ? preview.slice(0, 500) : preview
}

function compactLog(message: string): string {
  return message.length > 500 ? message.slice(0, 500) : message
}

function extractPathFromPatch(patchText: string, projectCwd: string): string | undefined {
  const openAiDeleteMatch = patchText.match(/^\*\*\* Delete File:\s+(.+)$/m)
  if (openAiDeleteMatch) {
    const path = openAiDeleteMatch[1].trim()
    return path && !path.startsWith("/") ? resolve(projectCwd, path) : path
  }

  const openAiAddMatch = patchText.match(/^\*\*\* Add File:\s+(.+)$/m)
  if (openAiAddMatch) {
    const path = openAiAddMatch[1].trim()
    return path && !path.startsWith("/") ? resolve(projectCwd, path) : path
  }

  const openAiMatch = patchText.match(/^\*\*\* Update File:\s+(.+)$/m)
  if (openAiMatch) {
    const path = openAiMatch[1].trim()
    return path && !path.startsWith("/") ? resolve(projectCwd, path) : path
  }

  const diffMatch = patchText.match(/^diff --git a\/(.+?) b\/(.+)$/m)
  if (diffMatch) {
    const path = diffMatch[2]
    return path && !path.startsWith("/") ? resolve(projectCwd, path) : path
  }

  const minusMatch = patchText.match(/^---\s+(.+)$/m)
  const plusMatch = patchText.match(/^\+\+\+\s+(.+)$/m)

  const normalize = (p?: string): string | undefined => {
    if (!p || p === "/dev/null") return
    if (p.startsWith("a/") || p.startsWith("b/")) return p.slice(2)
    return p
  }

  const plusPath = normalize(plusMatch?.[1])
  const minusPath = normalize(minusMatch?.[1])
  const resolved = plusPath ?? minusPath
  if (!resolved) return
  return resolved.startsWith("/") ? resolved : resolve(projectCwd, resolved)
}

function cleanupTempFiles(): void {
  try { unlinkSync(ORIG_FILE) } catch {}
  try { unlinkSync(PROP_FILE) } catch {}
}

// ── Tool name constants ───────────────────────────────────────────

const EDIT_TOOLS = new Set(["edit", "write", "multiedit", "apply_patch"])
const RM_PATTERN = /^(sudo\s+)?rm\s/

// ── Plugin entry point ────────────────────────────────────────────

const plugin: Plugin = async ({ directory }) => {
  const projectCwd = directory

  return {
    "tool.execute.before": async (input, output) => {
      const { tool } = input
      const args = output.args as Record<string, any>
      debugLog(`tool.execute.before tool=${tool}`)
      // ── Bash (rm detection) ───────────────────────────────
      if (tool === "bash") {
        const command: string = args.command ?? ""
        const subcmds = command.split(/[;&|]{1,2}/)
        const rmPaths: string[] = []

        for (const sub of subcmds) {
          const trimmed = sub.trim()
          if (!RM_PATTERN.test(trimmed)) continue

          const parts = trimmed
            .replace(/^(sudo\s+)?rm\s+/, "")
            .split(/\s+/)
            .filter((p) => !p.startsWith("-") && p.length > 0)

          for (const p of parts) {
            rmPaths.push(p.startsWith("/") ? p : resolve(projectCwd, p))
          }
        }

        if (rmPaths.length === 0) return

        const socket = findNvimSocket(projectCwd)
        debugLog(`tool.execute.before tool=${tool} socket=${Boolean(socket)}`)
        if (!socket) return

        for (const rmPath of rmPaths) {
          nvimSend(socket, `require('claude-preview.changes').set('${escapeLua(rmPath)}', 'deleted')`)
        }
        nvimSend(socket, "pcall(function() require('claude-preview.neo_tree').refresh() end)")
        nvimSend(
          socket,
          `vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').reveal('${escapeLua(rmPaths[0])}') end) end, 300)`,
        )
        return
      }

      // ── Skip non-edit tools ───────────────────────────────
      if (!EDIT_TOOLS.has(tool)) return

      // ── Compute original and proposed content ─────────────
      let filePath: string
      let original: string
      let proposed: string

      // Resolve filePath — the hook fires with raw LLM args which may
      // contain a relative path.  The tool itself resolves it inside
      // execute(), but that happens *after* the hook, so we must do it
      // here too.
      const resolveFilePath = (p: string) =>
        p && !p.startsWith("/") ? resolve(projectCwd, p) : p

      switch (tool) {
        case "edit": {
          filePath = resolveFilePath(args.filePath)
          original = readFileOrEmpty(filePath)
          proposed = applyEdit(
            original,
            args.oldString ?? "",
            args.newString ?? "",
            args.replaceAll ?? false,
          )
          break
        }

        case "write": {
          filePath = resolveFilePath(args.filePath)
          original = readFileOrEmpty(filePath)
          proposed = args.content ?? ""
          break
        }

        case "multiedit": {
          filePath = resolveFilePath(args.filePath)
          original = readFileOrEmpty(filePath)
          proposed = applyMultiEdit(original, args.edits ?? [])
          break
        }

        case "apply_patch": {
          const patchText: string = args.patchText ?? ""
          const extractedPath = extractPathFromPatch(patchText, projectCwd)
          debugLog(`tool.execute.before tool=${tool} apply_patch fileMatch=${Boolean(extractedPath)}`)
          if (!extractedPath) {
            debugLog(`tool.execute.before tool=${tool} apply_patch preview=${patchPreview(patchText)}`)
            return
          }

          filePath = extractedPath
          original = readFileOrEmpty(filePath)
          if (patchText.startsWith("*** Begin Patch")) {
            const firstHeader = patchText.match(/^\*\*\* (Add|Update|Delete) File:\s+.+$/m)
            const isDeletePatch = firstHeader?.[1] === "Delete"
            if (isDeletePatch) {
              proposed = ""
              break
            }
            let firstHunkLogged = false
            let matchFailed = false
            const openAiDebug = (msg: string): void => {
              try {
                const payload = JSON.parse(msg) as {
                  oldBlock?: string[]
                  newBlock?: string[]
                  match?: boolean
                }
                if (payload.match === false) matchFailed = true
                if (!firstHunkLogged && Array.isArray(payload.oldBlock) && Array.isArray(payload.newBlock)) {
                  const oldPreview = payload.oldBlock.slice(0, 3)
                  const newPreview = payload.newBlock.slice(0, 3)
                  const summary =
                    `tool.execute.before tool=${tool} apply_patch openai first_hunk ` +
                    `old=${payload.oldBlock.length} new=${payload.newBlock.length} ` +
                    `old3=${JSON.stringify(oldPreview)} new3=${JSON.stringify(newPreview)}`
                  debugLog(compactLog(summary))
                  firstHunkLogged = true
                }
              } catch {}
            }

            proposed = applyOpenAIPatch(original, patchText, openAiDebug)
            if (matchFailed) {
              debugLog(`tool.execute.before tool=${tool} apply_patch openai match=false`)
            }
            debugLog(`tool.execute.before tool=${tool} apply_patch applyOpenAIPatchNull=${proposed === null}`)
            if (proposed === null) return
          } else {
            proposed = applyUnifiedDiff(original, patchText)
            debugLog(`tool.execute.before tool=${tool} apply_patch applyUnifiedDiffNull=${proposed === null}`)
            if (proposed === null) return
          }
          break
        }

        default:
          return
      }

      // ── Write temp files ──────────────────────────────────
      writeFileSync(ORIG_FILE, original)
      writeFileSync(PROP_FILE, proposed)

      // ── Send to Neovim ────────────────────────────────────
      const socket = findNvimSocket(projectCwd)
      debugLog(`tool.execute.before tool=${tool} socket=${Boolean(socket)}`)
      if (!socket) return

      const displayName = relative(projectCwd, filePath) || filePath
      const changeStatus = existsSync(filePath) ? "modified" : "created"

      const origEsc = escapeLua(ORIG_FILE)
      const propEsc = escapeLua(PROP_FILE)
      const displayEsc = escapeLua(displayName)
      const filePathEsc = escapeLua(filePath)

      // Send all commands in a single pcall-wrapped block to avoid
      // one error blocking subsequent commands via --remote-send
      const revealCmd = changeStatus === "modified"
        ? `vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').reveal('${filePathEsc}') end) end, 300)`
        : (() => {
            let revealDir = dirname(filePath)
            while (!existsSync(revealDir) && revealDir !== "/") {
              revealDir = dirname(revealDir)
            }
            return `vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').reveal('${escapeLua(revealDir)}') end) end, 300)`
          })()

      const luaBlock = [
        `pcall(function() require('claude-preview.changes').set('${filePathEsc}', '${changeStatus}') end)`,
        `pcall(function() require('claude-preview.neo_tree').refresh() end)`,
        `pcall(function() ${revealCmd} end)`,
        `local ok, err = pcall(function() require('claude-preview.diff').show_diff('${origEsc}', '${propEsc}', '${displayEsc}') end)`,
        `if not ok then vim.notify('claude-preview show_diff error: ' .. tostring(err), vim.log.levels.ERROR) end`,
      ].join(" ")

      if (!nvimSend(socket, luaBlock)) {
        debugLog(`tool.execute.before tool=${tool} nvimSend=false show_diff`)
      }
    },

    "tool.execute.after": async (input, _output) => {
      const { tool } = input
      // For bash (rm detection), only clear deletion markers
      if (tool === "bash") {
        const socket = findNvimSocket(projectCwd)
        if (!socket) return

        nvimSend(socket, [
          "pcall(function() require('claude-preview.changes').clear_by_status('deleted') end)",
          "vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').refresh() end) end, 200)",
        ].join(" "))
        return
      }

      if (!EDIT_TOOLS.has(tool)) return

      const socket = findNvimSocket(projectCwd)
      if (!socket) return

      const args = input.args as Record<string, any>
      const rawPath: string | undefined = args?.filePath
      const filePath = rawPath && !rawPath.startsWith("/") ? resolve(projectCwd, rawPath) : rawPath

      // Send all cleanup commands in a single batch
      const luaLines = [
        "pcall(function() require('claude-preview.changes').clear_all() end)",
        "pcall(function() require('claude-preview.diff').close_diff() end)",
      ]

      if (filePath) {
        const filePathEsc = escapeLua(filePath)
        luaLines.push(
          `vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').refresh() end) vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').reveal('${filePathEsc}') end) end, 200) end, 200)`,
        )
      } else {
        luaLines.push(
          "vim.defer_fn(function() pcall(function() require('claude-preview.neo_tree').refresh() end) end, 200)",
        )
      }

      nvimSend(socket, luaLines.join(" "))

      cleanupTempFiles()
    },
  }
}

export default plugin
