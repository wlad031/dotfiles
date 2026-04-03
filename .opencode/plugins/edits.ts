// edits.ts — Edit computation helpers
//
// Pure functions that compute proposed file content by applying
// find-and-replace edits. Mirrors the logic in bin/apply-edit.lua
// and bin/apply-multi-edit.lua.

import { readFileSync } from "fs"

/** Apply a single find-and-replace edit to content. */
export function applyEdit(
  content: string,
  oldString: string,
  newString: string,
  replaceAll = false,
): string {
  if (oldString === "") return content

  if (replaceAll) {
    return content.split(oldString).join(newString)
  }

  const idx = content.indexOf(oldString)
  if (idx === -1) return content
  return content.substring(0, idx) + newString + content.substring(idx + oldString.length)
}

/** Apply multiple sequential find-and-replace edits to content. */
export function applyMultiEdit(
  content: string,
  edits: Array<{ oldString: string; newString: string; replaceAll?: boolean }>,
): string {
  for (const edit of edits) {
    const old = edit.oldString ?? ""
    const replacement = edit.newString ?? ""
    if (old === "") {
      content = replacement + content
    } else {
      const idx = content.indexOf(old)
      if (idx !== -1) {
        content = content.substring(0, idx) + replacement + content.substring(idx + old.length)
      }
    }
  }
  return content
}

type HunkHeader = {
  oldStart: number
  oldCount: number
  newStart: number
  newCount: number
}

const HUNK_HEADER = /^@@\s+-(\d+)(?:,(\d+))?\s+\+(\d+)(?:,(\d+))?\s+@@/

/**
 * Apply unified diff hunks to original content.
 * Returns null if the patch cannot be applied strictly.
 */
export function applyUnifiedDiff(original: string, patchText: string): string | null {
  const lines = patchText.split(/\r?\n/)
  const origLines = original.split(/\n/)
  const output: string[] = []

  let origIndex = 0
  let inHunks = false
  let didApply = false

  let current: HunkHeader | null = null
  let seenOld = 0
  let seenNew = 0

  const finalizeHunk = (): boolean => {
    if (!current) return true
    if (seenOld !== current.oldCount || seenNew !== current.newCount) return false
    current = null
    seenOld = 0
    seenNew = 0
    return true
  }

  const startHunk = (header: HunkHeader): boolean => {
    if (!finalizeHunk()) return false

    const startIdx = header.oldStart - 1
    if (startIdx < origIndex || startIdx > origLines.length) return false

    output.push(...origLines.slice(origIndex, startIdx))
    origIndex = startIdx
    current = header
    didApply = true
    return true
  }

  for (const line of lines) {
    const headerMatch = line.match(HUNK_HEADER)
    if (headerMatch) {
      inHunks = true
      const header: HunkHeader = {
        oldStart: Number(headerMatch[1]),
        oldCount: headerMatch[2] ? Number(headerMatch[2]) : 1,
        newStart: Number(headerMatch[3]),
        newCount: headerMatch[4] ? Number(headerMatch[4]) : 1,
      }
      if (!startHunk(header)) return null
      continue
    }

    if (!inHunks) {
      continue
    }

    if (/^(---|\+\+\+)\s/.test(line)) {
      break
    }

    if (line === "\\ No newline at end of file") {
      continue
    }

    const prefix = line[0]
    const content = line.slice(1)

    if (prefix === " ") {
      if (origLines[origIndex] !== content) return null
      output.push(content)
      origIndex += 1
      seenOld += 1
      seenNew += 1
      continue
    }

    if (prefix === "-") {
      if (origLines[origIndex] !== content) return null
      origIndex += 1
      seenOld += 1
      continue
    }

    if (prefix === "+") {
      output.push(content)
      seenNew += 1
      continue
    }

    return null
  }

  if (!inHunks || !didApply) return null
  if (!finalizeHunk()) return null

  output.push(...origLines.slice(origIndex))
  return output.join("\n")
}

/**
 * Apply OpenAI "*** Begin Patch" hunks to original content.
 * Returns null if the patch cannot be applied strictly.
 */
export function applyOpenAIPatch(
  original: string,
  patchText: string,
  debug?: (msg: string) => void,
): string | null {
  const lines = patchText.split(/\r?\n/)
  let firstFileHeader: { type: "add" | "update" | "delete"; index: number } | null = null
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]
    if (line.startsWith("*** Add File:")) {
      firstFileHeader = { type: "add", index: i }
      break
    }
    if (line.startsWith("*** Update File:")) {
      firstFileHeader = { type: "update", index: i }
      break
    }
    if (line.startsWith("*** Delete File:")) {
      firstFileHeader = { type: "delete", index: i }
      break
    }
  }

  if (firstFileHeader?.type === "add") {
    const addLines: string[] = []
    for (let i = firstFileHeader.index + 1; i < lines.length; i++) {
      const line = lines[i]
      if (line.startsWith("***")) break
      if (line.startsWith("@@")) continue
      if (line.startsWith("+")) {
        addLines.push(line.slice(1))
      } else {
        addLines.push(line)
      }
    }

    if (debug) {
      debug(JSON.stringify({ addFile: true, lines: addLines.length }))
    }

    return addLines.length === 0 ? "" : addLines.join("\n")
  }

  if (firstFileHeader?.type === "delete") {
    if (debug) {
      debug(JSON.stringify({ deleteFile: true }))
    }
    return ""
  }

  let currentLines = original.split(/\n/)

  let inFile = false
  let seenFile = false
  let inHunk = false
  let didApply = false
  let hunkLines: string[] = []

  const applyHunk = (linesToApply: string[]): boolean => {
    const oldBlock: string[] = []
    const newBlock: string[] = []

    for (const line of linesToApply) {
      if (line === "\\ No newline at end of file") continue

      let prefix = line[0]
      let content = line.slice(1)
      if (!prefix) {
        prefix = " "
        content = ""
      } else if (prefix !== " " && prefix !== "+" && prefix !== "-") {
        prefix = " "
        content = line
      }

      if (prefix === " " || prefix === "-") oldBlock.push(content)
      if (prefix === " " || prefix === "+") newBlock.push(content)
    }

    const emitDebug = (matched: boolean, extra: Record<string, unknown> = {}): void => {
      if (!debug) return
      debug(JSON.stringify({ oldBlock, newBlock, match: matched, ...extra }))
    }

    if (oldBlock.length === 0) {
      emitDebug(true)
      currentLines = currentLines.concat(newBlock)
      return true
    }

    let matchIndex = -1
    for (let i = 0; i <= currentLines.length - oldBlock.length; i++) {
      let matches = true
      for (let j = 0; j < oldBlock.length; j++) {
        if (currentLines[i + j] !== oldBlock[j]) {
          matches = false
          break
        }
      }
      if (matches) {
        matchIndex = i
        break
      }
    }

    let fuzzyMatched = false
    if (matchIndex === -1 && oldBlock.length === 1 && newBlock.length === 1) {
      const oldLine = oldBlock[0]
      let fuzzyIndex = -1
      for (let i = 0; i < currentLines.length; i++) {
        if (currentLines[i].startsWith(oldLine)) {
          fuzzyIndex = i
          break
        }
      }
      if (fuzzyIndex === -1) {
        for (let i = 0; i < currentLines.length; i++) {
          if (currentLines[i].includes(oldLine)) {
            fuzzyIndex = i
            break
          }
        }
      }
      if (fuzzyIndex !== -1) {
        matchIndex = fuzzyIndex
        fuzzyMatched = true
        emitDebug(true, { fuzzy: true })
      }
    }

    const matched = matchIndex !== -1
    if (!matched) {
      emitDebug(false)
      return false
    }
    if (matched && !fuzzyMatched) emitDebug(true)

    currentLines = [
      ...currentLines.slice(0, matchIndex),
      ...newBlock,
      ...currentLines.slice(matchIndex + oldBlock.length),
    ]
    return true
  }

  for (const line of lines) {
    if (line.startsWith("*** Update File:")) {
      if (seenFile) {
        if (inHunk) {
          if (!applyHunk(hunkLines)) return null
          didApply = true
        }
        break
      }
      seenFile = true
      inFile = true
      continue
    }

    if (!inFile) continue

    if (line.startsWith("***")) {
      if (inHunk) {
        if (!applyHunk(hunkLines)) return null
        didApply = true
      }
      break
    }

    if (line.startsWith("@@")) {
      if (inHunk) {
        if (!applyHunk(hunkLines)) return null
        didApply = true
      }
      inHunk = true
      hunkLines = []
      continue
    }

    if (!inHunk) continue
    hunkLines.push(line)
  }

  if (!seenFile) return null

  if (inHunk) {
    if (!applyHunk(hunkLines)) return null
    didApply = true
  }

  if (!didApply) return null
  return currentLines.join("\n")
}

/** Read a file's content, returning empty string if it doesn't exist. */
export function readFileOrEmpty(filePath: string): string {
  try {
    return readFileSync(filePath, "utf-8")
  } catch {
    return ""
  }
}
