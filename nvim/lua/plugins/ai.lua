return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        disable_keymaps = true,
        disable_inline_completion = true,
      })
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "hrsh7th/nvim-cmp" },
      -- { 'Saghen/blink.cmp' },
    },
    config = function()
      require("minuet").setup({
        provider = "codestral",
        provider_options = {
          codestral = {
            -- max_tokens = 512,
            -- model = 'claude-3-5-haiku-20241022',
            -- system = "see [Prompt] section for the default value",
            -- few_shots = "see [Prompt] section for the default value",
            -- chat_input = "See [Prompt Section for default value]",
            -- stream = true,
            api_key = "OPENROUTER_API_KEY",

            optional = {
              -- stop_sequences = nil,
            },
          },
          openai_compatible = {
            api_key = "OPENROUTER_API_KEY",
          },
        },
      })
    end,
  },
  {
    -- avante.nvim is a Neovim plugin designed to emulate the behaviour of the
    -- Cursor AI IDE. It provides users with AI-driven code suggestions and the
    -- ability to apply these recommendations directly to their source files
    -- with minimal effort.
    -- https://github.com/yetone/avante.nvim
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "openai",
      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        model = "openai/o1-mini",
        api_key_name = "OPENROUTER_API_KEY",
        temperature = 0.6,
        max_tokens = 12000,
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      -- {
      --   -- Make sure to set this up properly if you have lazy=true
      --   'MeanderingProgrammer/render-markdown.nvim',
      --   opts = {
      --     file_types = { "markdown", "Avante" },
      --   },
      --   ft = { "markdown", "Avante" },
      -- },
    },
  },
  {
    -- parrot.nvim offers a seamless out-of-the-box experience, providing tight
    -- integration of current LLM APIs into your Neovim workflows, with a focus
    -- solely on text generation. The selected core features include on-demand
    -- text completion and editing, as well as chat-like sessions within native
    -- Neovim buffers. While this project is still under development,
    -- a substantial part of the code is based on an early fork of the
    -- brilliant work by Tibor Schmidt's gp.nvim.
    -- https://github.com/frankroeder/parrot.nvim
    "frankroeder/parrot.nvim",
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
    config = function()
      require("parrot").setup({
        -- Providers must be explicitly added to make them available.
        providers = {
          -- anthropic = {
          --   api_key = os.getenv "ANTHROPIC_API_KEY",
          -- },
          -- gemini = {
          --   api_key = os.getenv "GEMINI_API_KEY",
          -- },
          -- groq = {
          --   api_key = os.getenv "GROQ_API_KEY",
          -- },
          -- mistral = {
          --   api_key = os.getenv "MISTRAL_API_KEY",
          -- },
          -- pplx = {
          --   api_key = os.getenv "PERPLEXITY_API_KEY",
          -- },
          -- provide an empty list to make provider available (no API key required)
          -- ollama = {},
          openai = {
            api_key = os.getenv("OPENAI_API_KEY"),
          },
          -- github = {
          --   api_key = os.getenv "GITHUB_TOKEN",
          -- },
          -- nvidia = {
          --   api_key = os.getenv "NVIDIA_API_KEY",
          -- },
          -- xai = {
          --   api_key = os.getenv "XAI_API_KEY",
          -- },
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    opts = {},
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
