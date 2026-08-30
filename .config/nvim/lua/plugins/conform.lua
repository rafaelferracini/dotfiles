return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- Define os formatadores específicos para cada linguagem
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				tex = { "latexindent" },
				c = { "clang-format" },
			},

			-- Formatar e indentar automaticamente ao salvar
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 2000,
			},
		})

		-- Atalho para formatar manualmente
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Conform: Formatar arquivo" })
	end,
}
