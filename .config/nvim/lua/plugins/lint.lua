return {
	"mfussenegger/nvim-lint",
	-- Carrega o plugin automaticamente ao abrir um arquivo
	event = { "BufReadPre", "BufNewFile" },

	dependencies = { "williamboman/mason.nvim" },

	config = function()
		local lint = require("lint")

		-- Define os linters específicos para cada linguagem
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			--			markdown = { "markdownlint" },
			--			cpp = { "cpplint" },
			--			python = { "flake8" },
			lua = { "luacheck" },
		}

		-- Cria um grupo de eventos para executar o linter automaticamente
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- O linter vai rodar ao abrir o arquivo, ao salvar e ao sair do modo de inserção
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
