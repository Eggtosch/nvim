-- set Ctrl-q as alias for Esc
vim.keymap.set("i", "<C-q>", "<Esc>")
vim.keymap.set("n", "<C-q>", "<Esc>")
vim.keymap.set("v", "<C-q>", "<Esc>")
vim.keymap.set("s", "<C-q>", "<Esc>")

-- enable line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes:1"

-- tab settings
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false
vim.g.ruby_recommended_style = false

-- wrap the arrow and hjkl keys
vim.opt.whichwrap:append {
	['<'] = true,
	['>'] = true,
	['['] = true,
	[']'] = true,
	h = true,
	l = true,
}

-- enable system wide clipboard
vim.opt.clipboard:append("unnamedplus")

-- hide the bottom status bar
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.laststatus = 0
vim.opt.showcmd = false

-- set the color scheme
vim.cmd("colorscheme cinnabar")
vim.opt.termguicolors = true

-- set default language
vim.cmd [[language en_US.UTF-8]]

-- confirm dialog on unsaved or read-only files
vim.opt.confirm = true

-- persist undo history even after file close
vim.opt.undofile = true

-- expand all blocks
vim.opt.foldlevelstart = 99

-- show tabline and cycle through tabs with tab and Shift-tab
vim.opt.showtabline = 1
vim.keymap.set("n", "<tab>", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "<s-tab>", "<cmd>tabprevious<cr>", { silent = true })

-- indent in next line after an opening {
vim.cmd("let delimitMate_expand_cr = 2")

-- shortcut for fzf
vim.keymap.set("n", "ff", "<cmd>FzfLua files<cr>", { silent = true })
vim.keymap.set("n", "fg", "<cmd>FzfLua live_grep<cr>", { silent = true })

-- run rustfmt on save
local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 200 })
	end,
	group = format_sync_grp,
})

-- open lsp diagnostics window with of
vim.keymap.set("n", "of", "<cmd>lua vim.diagnostic.open_float()<cr>")

-- plugin stuff
local ensure_packer = function()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	local packer_git = "https://github.com/wbthomason/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({"git", "clone", "--depth", "1", packer_git, install_path})
		vim.cmd("packadd packer.nvim")
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

package.path = "/home/oskar/.config/nvim/?.lua;" .. package.path

return require("packer").startup {
	function(use)
		-- packer itself
		use { "wbthomason/packer.nvim" }

		-- nerd font icons
		use { "nvim-tree/nvim-web-devicons" }

		-- auto completion
		use { "SirVer/ultisnips", event = "InsertEnter" }
		use { "hrsh7th/nvim-cmp", config = [[require('config.nvim-cmp')]] }
		use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
		use { "hrsh7th/cmp-path", after = "nvim-cmp" }
		use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
		use { "quangnguyen30192/cmp-nvim-ultisnips", after = { "nvim-cmp", "ultisnips" } }

		-- lsp stuff
		use { "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.lsp')]] }
		use { "rust-lang/rust.vim", event = "VimEnter" }

		-- display lsp status messages
		use { "j-hui/fidget.nvim", after = "nvim-lspconfig", config = [[require('config.fidget')]] }

		-- nvim status line
		use { "nvim-lualine/lualine.nvim", event = "VimEnter", config = [[require('config.lualine')]] }

		-- dashboard when opening nvim without a file
		use { "glepnir/dashboard-nvim", event = "VimEnter", config = [[require('config.dashboard')]] }

		-- see git diff signs in number column
		use { "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]] }

		-- remember last cursor position in files
		use { 'ethanholz/nvim-lastplace', config = [[require('config.lastplace')]] }

		-- auto close parenthesis
		use { 'Raimondi/delimitMate' }

		-- fzf
		use { 'ibhagwan/fzf-lua' }

		-- remember recently used files
		use { 'yegappan/mru' }

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		}
	}
}

