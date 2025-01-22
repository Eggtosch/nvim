-- set leader key
vim.g.mapleader = ","

-- set Ctrl-q as alias for Esc
vim.keymap.set("i", "<C-q>", "<Esc>")
vim.keymap.set("n", "<C-q>", "<Esc>")
vim.keymap.set("v", "<C-q>", "<Esc>")
vim.keymap.set("s", "<C-q>", "<Esc>")

vim.keymap.set("n", "<Up>", "gk")
vim.keymap.set("n", "<Down>", "gj")

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

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- show tabline and cycle through tabs with tab and Shift-tab
-- fzflua opens file in new tab with Ctrl-t
vim.opt.showtabline = 1
vim.keymap.set("n", "<tab>", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "<s-tab>", "<cmd>tabprevious<cr>", { silent = true })

-- open and close diffview
vim.keymap.set("n", "<Leader>do", "<cmd>DiffviewOpen<cr>", { silent = true })
vim.keymap.set("n", "<Leader>dc", "<cmd>DiffviewClose<cr>", { silent = true })

-- switch between panes
-- fzflua does split with Ctrl-s and vsplit with Ctrl-v
vim.keymap.set("n", "<C-S-Up>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-S-Down>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-S-Left>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-S-Right>", "<C-w>l", { silent = true })

-- indent in next line after an opening {
vim.cmd("let delimitMate_expand_cr = 2")

-- shortcuts for fzf
vim.keymap.set("n", "<Leader>ff", "<cmd>FzfLua files<cr>", { silent = true })
vim.keymap.set("n", "<Leader>fg", "<cmd>FzfLua live_grep<cr>", { silent = true })
vim.keymap.set("n", "<Leader>gg", "<cmd>FzfLua git_bcommits<cr>", { silent = true })
vim.keymap.set("n", "<Leader>man", "<cmd>FzfLua manpages<cr>", { silent = true })

-- shortcuts for nvim-tree
vim.keymap.set("n", "<Leader>bf", "<cmd>NvimTreeFocus<cr>", { silent = true })

-- shortcuts for lazygit
vim.keymap.set("n", "<Leader>lg", "<cmd>LazyGit<cr>", { silent = true })

-- run rustfmt on save
local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 200 })
	end,
	group = format_sync_grp,
})

-- lsp keybinds
vim.keymap.set("n", "<Leader>of", vim.diagnostic.open_float)
vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<Leader>rn", function() vim.lsp.buf.rename() vim.cmd("wa") end)

vim.lsp.set_log_level("off")

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

package.path = vim.env.HOME .. "/.config/nvim/?.lua;" .. package.path

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

		-- file browser
		use { "nvim-tree/nvim-tree.lua", config = [[require('config.nvim-tree')]] }

		-- git stuff
		use { "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]] }
		use { "sindrets/diffview.nvim" }
		use { "tpope/vim-fugitive" }

		-- remember last cursor position in files
		use { 'ethanholz/nvim-lastplace', config = [[require('config.lastplace')]] }

		-- auto close parenthesis
		use { 'windwp/nvim-autopairs', config = [[require('config.autopairs')]] }

		-- fzf
		use { 'ibhagwan/fzf-lua', config = [[require('config.fzf')]] }

		-- remember recently used files
		use { 'yegappan/mru' }

		-- render markdown files in browser
		use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end }

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

