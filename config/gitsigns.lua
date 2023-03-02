require("gitsigns").setup {
	signs = {
		add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr" },
		change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr" },
		delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr" },
	},
}
