local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")

if vim.fn.executable("clangd") > 0 then
	lspconfig.clangd.setup {
		capabilities = capabilities,
		filetypes = {"c", "cpp", "cc"},
		cmd = {"clangd", "--header-insertion=never"},
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
