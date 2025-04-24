return {
  'milanglacier/minuet-ai.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  config = function()
    require('minuet').setup {
      provider = 'codestral',
      provider_options = {
        codestral = {
          -- max_tokens = 512,
          -- model = 'claude-3-5-haiku-20241022',
          -- system = "see [Prompt] section for the default value",
          -- few_shots = "see [Prompt] section for the default value",
          -- chat_input = "See [Prompt Section for default value]",
          -- stream = true,
          api_key = 'OPENROUTER_API_KEY',

          optional = {
            -- stop_sequences = nil,
          },
        },
        openai_compatible = {
          api_key = 'OPENROUTER_API_KEY',
        }
      }
    }
  end,
}
