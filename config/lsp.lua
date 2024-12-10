local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")

local query_drivers = {"/usr/bin/gcc", "/usr/bin/clang"}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function clangd_fmt(client, bufnr)
	local fmt_path = vim.fn.resolve(vim.fn.getcwd() .. "/.clang-format")
	if vim.fn.empty(vim.fn.glob(fmt_path)) > 0 then
		return
	end
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end
end

if vim.fn.executable("clangd") > 0 then
	lspconfig.clangd.setup {
		capabilities = capabilities,
		filetypes = {"c", "cpp", "cc"},
		cmd = {
			"clangd",
			"--header-insertion=never",
			"--query-driver=" .. table.concat(query_drivers, ",")
		},
		on_attach = clangd_fmt,
	}
end

if vim.fn.executable("rust-analyzer") > 0 then
	lspconfig.rust_analyzer.setup {
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					disabled = {"unresolved-proc-macro"}
				}
			}
		}
	}
end

if vim.fn.executable("lua-language-server") > 0 then
	local project_path = vim.fn.resolve(vim.fn.getcwd())
	local workspace_settings = {}
	if string.find(project_path, ".config/nvim") then
		workspace_settings = {
			checkThirdParty = false,
			library = { vim.env.VIMRUNTIME }
		}
	end
	lspconfig.lua_ls.setup {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = workspace_settings,
			}
		}
	}
end

-- https://github.com/arduino/arduino-language-server/pull/199
if vim.fn.executable("arduino-language-server") > 0 then
	lspconfig.arduino_language_server.setup {}
end

if vim.fn.executable("pylsp") > 0 then
	lspconfig.pylsp.setup {}
end

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.diagnostic.config {
	underline = false,
	virtual_text = true,
	signs = true,
	severity_sort = true,
}
