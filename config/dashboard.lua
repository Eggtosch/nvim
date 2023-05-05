local header = {
  "                                                       ",
  "                                                       ",
  "                                                       ",
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
  "                                                       ",
  "                                                       ",
  "                                                       ",
  "                                                       ",
}

local center = {
	{
		icon = "  ",
		desc = "New file",
		action = "enew",
	},
	{
		icon = "  ",
		desc = "Find file",
		action = "FzfLua files",
	},
	{
		icon = "  ",
		desc = "Recent files",
		action = "FzfLua oldfiles",
	},
	{
		icon = "  ",
		desc = "Quit Nvim",
		action = "qa",
	},
}

require("dashboard").setup {
	theme = "doom",
	config = {
		header = header,
		center = center,
	},
	hide = {
		tabline = false,
	},
}

