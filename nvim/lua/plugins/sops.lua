return {
  "wlad031/nvim-sops",
  url = "git@gitea.local.vgerasimov.dev:wlad031/nvim-sops.git",
  lazy = false,
  config = function(_, opts)
    require("nvim-sops").setup(opts)
  end,
  opts = {},
}
