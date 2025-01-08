local fzf = require("fzf-lua")
local files = fzf.defaults.files

fzf.setup {
	files = {
		fd_opts = files.fd_opts:gsub(files.toggle_hidden_flag, ""),
		actions = {
			["ctrl-h"] = { fzf.actions.toggle_hidden }
		}
	}
}
