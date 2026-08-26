-- Leader
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- No modo visual, permite mover blocos de código, inclusive para dentro de blocos como if
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Mantém o cursor onde está ao usar o J, ao invez de ir para o final da linha
vim.keymap.set("n", "J", "mzJ`z")

-- Mantém o cursor no meio enquanto pula meia página
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Navegar entre os buffers abertos recentemente
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Próximo buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })

-- Não entendi
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Não perde o item copiado ao sobreescrever outro com ele
vim.keymap.set("x", "<leader>p", '"_dP')

-- Opção para yarn no clipboard para poder colar coisas fora do ambiente
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- Navegação mais fácil entre as janelas (splits)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir para a janela à esquerda" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir para a janela abaixo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir para a janela acima" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir para a janela à direita" })

-- Atalho no Neovim para disparar a criação de figuras via Rofi
vim.keymap.set("n", "<C-i>", function()
	local file = vim.api.nvim_buf_get_name(0)
	vim.fn.jobstart({ "/home/rafaelf/.config/nvim/scripts/inkscape-figures.py", file }, { detach = true })
end, { desc = "Criar/Editar figura no Inkscape" })

vim.keymap.set("n", "<leader>ch", function()
	local current_file = vim.api.nvim_buf_get_name(0)
	local target_file = ""

	if current_file:match("%.h$") then
		-- Se estiver no .h, tenta achar o .cpp correspondente na pasta src/
		target_file = current_file:gsub("include", "src"):gsub("%.h$", ".cpp")
	elseif current_file:match("%.cpp$") then
		-- Se estiver no .cpp, tenta achar o .h correspondente na pasta include/
		target_file = current_file:gsub("src", "include"):gsub("%.cpp$", ".h")
	end

	if target_file ~= "" then
		-- Verifica se o arquivo alternativo realmente existe antes de abrir
		local f = io.open(target_file, "r")
		if f ~= nil then
			io.close(f)
			vim.cmd("edit " .. target_file)
		else
			vim.notify(
				"Arquivo correspondente não encontrado: " .. target_file,
				vim.log.levels.WARN,
				{ title = "C++ Alt" }
			)
		end
	end
end, { desc = "C++: Alternar entre .h e .cpp" })

-- ============================================================================
-- ATALHOS PARA COMPILAÇÃO E EXECUÇÃO DE C++ NO NEOVIM / LAZYVIM
-- ============================================================================

-- <F5>: Compila TODOS os arquivos .cpp da pasta src/ + include/
vim.keymap.set("n", "<F5>", function()
	vim.cmd("w") -- Salva o arquivo atual
	local dir = vim.fn.expand("%:p:h")

	-- Compila a pasta inteira com -g (debug) e executa
	local cmd = string.format('split | terminal cd "%s" && g++ -g -I../include *.cpp -o ../bin_out && ../bin_out', dir)
	vim.cmd(cmd)
end, { desc = "Compilar e Executar C++ (Projeto Inteiro)" })

-- <F6>: Compila APENAS o arquivo .cpp atual + include/
vim.keymap.set("n", "<F6>", function()
	vim.cmd("w") -- Salva o arquivo atual
	local dir = vim.fn.expand("%:p:h")
	local file = vim.fn.expand("%:t") -- Nome do arquivo aberto (ex: main.cpp)

	-- Compila apenas o arquivo do buffer atual com -g (debug) e executa
	local cmd =
		string.format('split | terminal cd "%s" && g++ -g -I../include "%s" -o ../bin_out && ../bin_out', dir, file)
	vim.cmd(cmd)
end, { desc = "Compilar e Executar C++ (Arquivo Atual)" })

-- <F7>: Compila apenas o binário com -g (sem executar), pronto para abrir no Debugger (DAP)
vim.keymap.set("n", "<F7>", function()
	vim.cmd("w") -- Salva o arquivo atual
	local dir = vim.fn.expand("%:p:h")
	local file = vim.fn.expand("%:t")

	-- Apenas compila o arquivo atual gerando o executável bin_out com símbolos de debug
	local cmd = string.format('split | terminal cd "%s" && g++ -g -I../include "%s" -o ../bin_out', dir, file)
	vim.cmd(cmd)
	print("Binário compilado para debug em ../bin_out (-g)")
end, { desc = "Compilar C++ para Debugger (-g)" })
