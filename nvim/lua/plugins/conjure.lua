return {
  {
    -- Conjure is an interactive environment for evaluating code within your
    -- running program.
    -- https://github.com/Olical/conjure
    "Olical/conjure",
    ft = { "clojure", "clojurescript", "clojurec" },
    init = function()
      vim.g["conjure#eval#inline#results"] = true
      vim.g["conjure#eval#inline#highlight"] = "Comment"
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#highlight#group"] = "IncSearch"

      vim.g["conjure#log#hud#enabled"] = true
      vim.g["conjure#log#hud#width"] = 0.42
      vim.g["conjure#log#hud#height"] = 0.3
      vim.g["conjure#log#hud#anchor"] = "NE"

      vim.g["conjure#filetypes"] = {
        "clojure",
        "clojurescript",
        "clojurec",
        "elixir",
        "fennel",
        "janet",
        "hy",
        "julia",
        "racket",
        "scheme",
        "lua",
        "lisp",
        "python",
        "ruby",
        "rust",
        "sql",
      }
      vim.g["conjure#filetype#clojure"] = "conjure.client.clojure.nrepl"
      vim.g["conjure#filetype#clojurescript"] = "conjure.client.clojure.nrepl"
      vim.g["conjure#filetype#clojurec"] = "conjure.client.clojure.nrepl"
    end,
  },
}
