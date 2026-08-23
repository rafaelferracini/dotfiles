-- Atalho no Neovim para disparar a criação de figuras via Rofi
vim.keymap.set("n", "<C-f>", function()
	local file = vim.api.nvim_buf_get_name(0)
	vim.fn.jobstart({ "/home/rafaelf/.config/nvim/scripts/inkscape-figures.py", file }, { detach = true })
end, { desc = "Criar/Editar figura no Inkscape" })
