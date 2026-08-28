return {
	"echasnovski/mini.pairs",
	version = false, -- Opcional: Garante que você sempre use a versão mais recente do branch principal
	event = "InsertEnter", -- Só carrega o plugin quando você começar a digitar algo (Modo Insert)
	config = function()
		require("mini.pairs").setup({
			-- O mini.pairs funciona perfeitamente sem nenhuma configuração extra,
			-- mantendo a filosofia de ser leve e direto ao ponto.

			-- Aqui você poderia mapear caracteres diferentes se quisesse,
			-- mas o padrão já cobre (), [], {}, "", e ''.
		})
	end,
}
