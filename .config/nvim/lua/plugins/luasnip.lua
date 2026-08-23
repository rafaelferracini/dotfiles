return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	config = function()
		local ls = require("luasnip")

		-- Opções essenciais sugeridas pelo EJ Mastnak
		ls.config.set_config({
			enable_autosnippets = true, -- Permite expansão automática de snippets sem pressionar Tab
			update_events = "TextChanged,TextChangedI",
		})

		-- Atalhos para navegar pelos pontos de parada (jump) dentro do snippet
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(1) then
				ls.jump(1)
			end
		end)
		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end)

		-- Carrega os snippets da pasta lua/snippets/
		require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
	end,
}
