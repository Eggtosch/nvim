local cmp = require("cmp")

local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = ""
}

cmp.setup {
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "ultisnips" },
		{ name = "path" },
		{ name = "buffer", keyword_length = 2 },
	},
	mapping = cmp.mapping.preset.insert {
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
		["<CR>"] = cmp.mapping.confirm { select = true },
		["<C-e>"] = cmp.mapping.abort(),
		["<Esc>"] = cmp.mapping.close(),
	},
	formatting = {
		format = function(entry, vim_item)
			local size = 45
			local label = vim_item.abbr
			local truncated_label = vim.fn.strcharpart(label, 0, size)
			if truncated_label ~= label then
				vim_item.abbr = truncated_label .. '…'
			elseif string.len(label) < size then
				local padding = string.rep(' ', size - string.len(label))
				vim_item.abbr = label .. padding
			end

			vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				ultisnips = "[UltiSnips]",
				nvim_lua = "[Lua]",
			})[entry.source.name]

			return vim_item
		end,
	},
	completion = {
		keyword_length = 1,
		completeopt = "menu,noselect",
	},
}

