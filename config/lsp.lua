local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")

local query_drivers = {"/usr/bin/gcc", "/usr/bin/clang", "/home/oskar/.espressif/tools/xtensa-*-elf/*/xtensa-*-elf/bin/xtensa-*-elf-gcc"}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

if vim.fn.executable("clangd") > 0 then
	lspconfig.clangd.setup {
		capabilities = capabilities,
		filetypes = {"c", "cpp", "cc"},
		cmd = {
			"clangd",
			"--header-insertion=never",
			"--query-driver=" .. table.concat(query_drivers, ",")
		},
		on_attach = function(client, bufnr)
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
		end,
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
