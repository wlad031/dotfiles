local function has_binary(name)
  return vim.fn.executable(name) == 1
end

local function pick_vimtex_viewer()
  if has_binary("zathura") then
    return { method = "zathura" }
  end
  if has_binary("mupdf") then
    return { method = "mupdf" }
  end
  if has_binary("evince") then
    return { method = "evince" }
  end
  if has_binary("okular") then
    return { method = "okular" }
  end
  if has_binary("xdg-open") then
    return {
      method = "general",
      general_viewer = "xdg-open",
      general_options = "",
    }
  end
  return { method = "xdvi" }
end

local vimtex = {
  "lervag/vimtex",
  ft = { "tex", "plaintex", "latex", "bib", "cls", "sty" },
  init = function()
    local viewer = pick_vimtex_viewer()
    vim.g.vimtex_view_method = viewer.method
    if viewer.method == "general" then
      vim.g.vimtex_view_general_viewer = viewer.general_viewer
      vim.g.vimtex_view_general_options = viewer.general_options
    end
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      executable = "latexmk",
      options = {
        "-pdf",
        "-interaction=nonstopmode",
        "-halt-on-error",
        "-file-line-error",
        "-synctex=1",
      },
    }
    vim.g.vimtex_quickfix_mode = 2
    vim.g.vimtex_view_automatic = 1
  end,
  config = function()
    vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>", { desc = "LaTeX: Compile" })
    vim.keymap.set("n", "<leader>lv", function()
      local pdf = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":r") .. ".pdf"
      if has_binary("xdg-open") and vim.fn.filereadable(pdf) == 1 then
        vim.fn.jobstart({ "xdg-open", pdf }, { detach = true })
      else
        vim.cmd("VimtexView")
      end
    end, { desc = "LaTeX: View PDF" })
    vim.keymap.set("n", "<leader>lC", "<cmd>VimtexClean<CR>", { desc = "LaTeX: Clean auxiliary files" })
    vim.keymap.set("n", "<leader>lS", "<cmd>VimtexStop<CR>", { desc = "LaTeX: Stop build" })
    vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocOpen<CR>", { desc = "LaTeX: Open TOC" })
    vim.keymap.set("n", "<leader>lT", "<cmd>VimtexTocClose<CR>", { desc = "LaTeX: Close TOC" })
  end,
}

return {
  vimtex
}
