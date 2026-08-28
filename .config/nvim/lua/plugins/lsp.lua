return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Suporte a LSP
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- Autocompletar (nvim-cmp) e integrações
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",

		-- O LuaSnip você já tem, mas declaramos aqui como dependência
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets", -- Coleção de snippets úteis para várias linguagens
	},
	config = function()
		-- 1. Inicia o Mason (Gerenciador de downloads)
		require("mason").setup()

		-- 2. Habilidades de autocompletar que enviaremos aos servidores
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 3. Lista de linguagens para instalar automaticamente
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd", -- C e C++
				"ts_ls", -- JavaScript e TypeScript (antigo tsserver)
				"pyright", -- Python
				"lua_ls", -- Lua
				"marksman",
			},

			-- Configura todos os servidores instalados automaticamente
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				-- Configuração especial para o Lua parar de acusar que 'vim' não existe
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						},
					})
				end,
			},
		})

		-- 4. Injeta os atalhos APENAS quando um arquivo suportado pelo LSP for aberto
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(event)
				-- Função auxiliar para mapear teclas mais facilmente
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Seus atalhos adaptados para não dependerem do plugin Snacks/LazyVim
				map("<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
				map("gd", vim.lsp.buf.definition, "Goto Definition")

				-- Usando o Telescope para referências e implementações (muito mais bonito)
				map("gr", require("telescope.builtin").lsp_references, "References")
				map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
				map("gy", require("telescope.builtin").lsp_type_definitions, "Goto T[y]pe Definition")

				map("gD", vim.lsp.buf.declaration, "Goto Declaration")
				map("K", vim.lsp.buf.hover, "Hover")
				map("gK", vim.lsp.buf.signature_help, "Signature Help")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
				map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
				map("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens", "n")
				map("<leader>cr", vim.lsp.buf.rename, "Rename")

				-- Fallback nativo para pular entre as referências da palavra sob o cursor
				map("]]", function()
					vim.lsp.buf.document_highlight()
				end, "Highlight References")
				map("[[", function()
					vim.lsp.buf.clear_references()
				end, "Clear References")
			end,
		})
	end,
}
