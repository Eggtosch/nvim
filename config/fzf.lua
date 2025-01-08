local fzf = require("fzf-lua")
fzf.setup {
	files = {
		actions = {
			["ctrl-h"] = { fzf.actions.toggle_hidden }
		}
	}
}
