return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		-- Define o leitor de PDF (ex: zathura para Linux/macOS ou sumatrapdf para Windows)
		vim.g.vimtex_view_method = "zathura"

		-- Ativa a ocultação do código LaTeX bruto para deixar a matemática legível no editor
		vim.g.vimtex_syntax_conceal = {
			accents = 1,
			ligatures = 1,
			math_symbols = 1,
			greek = 1,
			styles = 1,
		}
	end,
}
