local M = {}

M.SetupLspConfig = function(lspconfig, capabilities)
	lspconfig.harper_ls.setup({
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
end

return M
