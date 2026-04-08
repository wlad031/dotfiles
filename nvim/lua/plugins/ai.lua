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
        notify = "warn",
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            model = "mistralai/devstral-small",
            stream = true,
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            api_key = "NVIM_MINUET_OPENAI_API_KEY",
            name = "Openrouter",
            optional = {
              stop = nil,
              max_tokens = nil,
            },
            transform = {},
          },
        },
      })
    end,
  },
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Opencode: Ask" })
      vim.keymap.set({ "n", "x" }, "<leader>os", function()
        require("opencode").select()
      end, { desc = "Opencode: Select" })
      vim.keymap.set({ "n", "t" }, "<leader>ot", function()
        require("opencode").toggle()
      end, { desc = "Opencode: Toggle" })
      vim.keymap.set("x", "<leader>or", function()
        require("opencode").ask("Replace this with answer: @this", { submit = true })
      end, { desc = "Opencode: Replace selection" })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:*",
        callback = function(args)
          if args.data and args.data.event and args.data.event.type == "session.idle" then
            vim.cmd("silent! checktime")

            local ok, neotree = pcall(require, "neo-tree.command")
            if ok then
              neotree.execute({ action = "refresh", source = "filesystem" })
            end
          end
        end,
      })
    end,
  },
  -- {
  --   -- avante.nvim is a Neovim plugin designed to emulate the behaviour of the
  --   -- Cursor AI IDE. It provides users with AI-driven code suggestions and the
  --   -- ability to apply these recommendations directly to their source files
  --   -- with minimal effort.
  --   -- https://github.com/yetone/avante.nvim
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  --   opts = {
  --     provider = "openai",
  --     providers = {
  --       openai = {
  --         endpoint = "https://openrouter.ai/api/v1",
  --         model = "openai/o1-mini",
  --         api_key_name = "NVIM_AVANTE_OPENAI_API_KEY",
  --         extra_request_body = {
  --           temperature = 0.6,
  --         },
  --         max_tokens = 12000,
  --       },
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     -- "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     -- {
  --     --   -- Make sure to set this up properly if you have lazy=true
  --     --   'MeanderingProgrammer/render-markdown.nvim',
  --     --   opts = {
  --     --     file_types = { "markdown", "Avante" },
  --     --   },
  --     --   ft = { "markdown", "Avante" },
  --     -- },
  --   },
  -- },
  -- {
  --   "nickjvandyke/opencode.nvim",
  --   version = "*",
  --   dependencies = {
  --     {
  --       "folke/snacks.nvim",
  --       optional = true,
  --       opts = {
  --         input = {},
  --         picker = {
  --           actions = {
  --             opencode_send = function(...)
  --               require("opencode").snacks_picker_send(...)
  --             end,
  --           },
  --           win = {
  --             input = {
  --               keys = {
  --                 ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  --   config = function()
  --     vim.g.opencode_opts = {}
  --     vim.o.autoread = true
  --
  --     vim.keymap.set({ "n", "x" }, "<leader>oa", function()
  --       require("opencode").ask("@this: ", { submit = true })
  --     end, { desc = "Opencode: Ask" })
  --     vim.keymap.set({ "n", "x" }, "<leader>os", function()
  --       require("opencode").select()
  --     end, { desc = "Opencode: Select" })
  --     vim.keymap.set({ "n", "t" }, "<leader>ot", function()
  --       require("opencode").toggle()
  --     end, { desc = "Opencode: Toggle" })
  --     vim.keymap.set("x", "<leader>or", function()
  --       require("opencode").ask("Replace this with answer: @this", { submit = true })
  --     end, { desc = "Opencode: Replace selection" })
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "OpencodeEvent:*",
  --       callback = function(args)
  --         if args.data and args.data.event and args.data.event.type == "session.idle" then
  --           vim.cmd("silent! checktime")
  --
  --           local ok, neotree = pcall(require, "neo-tree.command")
  --           if ok then
  --             neotree.execute({ action = "refresh", source = "filesystem" })
  --           end
  --         end
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --   "Cannon07/claude-preview.nvim",
  --   config = function()
  --     require("claude-preview").setup({
  --       neo_tree = {
  --         enabled = true,
  --         position = "right",
  --       },
  --     })
  --
  --     local group = vim.api.nvim_create_augroup("ClaudePreviewAutoread", { clear = true })
  --     vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  --       group = group,
  --       command = "checktime",
  --     })
  --   end,
  -- },
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
          openai = {
            name = "openai",
            api_key = os.getenv("OPENAI_API_KEY"),
            endpoint = "https://api.openai.com/v1/chat/completions",
            params = {
              chat = { temperature = 1.1, top_p = 1 },
              command = { temperature = 1.1, top_p = 1 },
            },
            topic = {
              model = "gpt-4.1-nano",
              params = { max_completion_tokens = 64 },
            },
            models = {
              "gpt-4o",
              "o4-mini",
              "gpt-4.1-nano",
            },
          },
        },
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = {
          adapter = "opencode",
        },
      },
      adapters = {
        acp = {
          opencode = function()
            return require("codecompanion.adapters").extend("opencode", {
            })
          end,
        },
      },
      -- NOTE: The log_level is in `opts.opts`
      opts = {
        log_level = "DEBUG",
      },
    },
  },
}
