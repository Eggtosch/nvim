function diamond_fmt(client, bufnr)
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

vim.lsp.start({
	cmd = { "diamond", "--lsp" },
	root_dir = vim.fn.getcwd(),
	on_attach = diamond_fmt,
})
