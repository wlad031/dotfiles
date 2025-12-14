local M = {}

M.SetupLsp = function(capabilities)
  vim.lsp.config("harper_ls", {
		capabilities = capabilities,
		settings = {
			["harper-ls"] = {
				userDictPath = "",
				fileDictPath = "",
				linters = {
					SpellCheck = false,
					SpelledNumbers = false,
					AnA = true,
					SentenceCapitalization = false,
					UnclosedQuotes = true,
					WrongQuotes = false,
					LongSentences = true,
					RepeatedWords = true,
					Spaces = true,
					Matcher = true,
					CorrectNumberSuffix = true,
				},
				codeActions = {
					ForceStable = false,
				},
				markdown = {
					IgnoreLinkTitle = false,
				},
				diagnosticSeverity = "hint",
				isolateEnglish = false,
			},
		},
	})
  vim.lsp.enable("harper_ls")
end

return M
