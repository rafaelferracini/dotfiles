return {
	"benomahony/uv.nvim",
	-- Carrega o plugin apenas ao abrir arquivos Python
	ft = "python",
	dependencies = {
		-- Recomendado para habilitar menus visuais (pickers):
		"nvim-telescope/telescope.nvim",
		-- ou "folke/snacks.nvim"
	},
	opts = {
		picker_integration = true,
	},
}
