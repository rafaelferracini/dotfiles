local M = {}
local ns = vim.api.nvim_create_namespace("tex_autosize")

-- Comandos altos que pedem delimitadores proporcionais ao conteúdo.
local tall = {
	frac = true,
	dfrac = true,
	tfrac = true,
	sum = true,
	prod = true,
	coprod = true,
	int = true,
	iint = true,
	iiint = true,
	oint = true,
	oiint = true,
	oiiint = true,
	binom = true,
	dbinom = true,
	tbinom = true,
}

-- O VimTeX desconta uma coluna em Insert; aqui as posições são explícitas.
local function in_math(row, col)
	local offset = vim.api.nvim_get_mode().mode:sub(1, 1) == "i" and 1 or 0
	return vim.fn["vimtex#syntax#in_mathzone"](row, col + offset) == 1
		and vim.fn["vimtex#syntax#in_comment"](row, col + offset) == 0
end

local function needs_size(open, close)
	if open.mod ~= "" or close.mod ~= "" then
		return false -- Preserva \left/\right e tamanhos manuais como \bigl/\bigr.
	end
	if not in_math(open.lnum, open.cnum) or not in_math(close.lnum, close.cnum) then
		return false
	end
	local lines =
		vim.api.nvim_buf_get_text(0, open.lnum - 1, open.cnum - 1 + #open.match, close.lnum - 1, close.cnum - 1, {})
	local depth, found = 0, false
	for index, line in ipairs(lines) do
		local col = 1
		while col <= #line do
			local ch = line:sub(col, col)
			if ch == "%" then
				break -- Ignora comentários; \% é consumido como comando abaixo.
			elseif ch == "\\" then
				local command = line:match("^\\([A-Za-z]+)", col)
				if command then
					-- \left e \right não podem atravessar ambientes ou linhas de alinhamento.
					if command == "begin" or command == "end" then
						return false
					end
					local start = index == 1 and open.cnum - 1 + #open.match or 0
					if tall[command] and in_math(open.lnum + index - 1, start + col) then
						found = true
					end
					col = col + #command + 1
				else
					if line:sub(col + 1, col + 1) == "\\" then
						return false
					end
					col = col + 2 -- Não confunde \{ e \} com grupos TeX.
				end
			else
				if ch == "&" then
					return false
				elseif ch == "{" then
					depth = depth + 1
				elseif ch == "}" then
					depth = depth - 1
					if depth < 0 then
						return false
					end
				end
				col = col + 1
			end
		end
	end
	return found and depth == 0
end

-- Ajusta os pares ao redor do cursor, inclusive pares aninhados e multilinha.
-- Insere só os modificadores: não substitui linhas nem recria nós do LuaSnip.
function M.update()
	local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
	if vim.bo.filetype ~= "tex" or not vim.bo.modifiable or mode == "s" or mode == "v" then
		return
	end
	local cursor = vim.api.nvim_win_get_cursor(0)
	if not in_math(cursor[1], cursor[2] + 1) and not in_math(cursor[1], math.max(1, cursor[2])) then
		return
	end
	local edits, seen = {}, {}
	local ok, err = pcall(function()
		-- A posição anterior cobre o fechamento digitado quando o cursor já passou dele.
		for _, column in ipairs({ cursor[2], math.max(0, cursor[2] - 1) }) do
			vim.api.nvim_win_set_cursor(0, { cursor[1], column })
			while true do
				local pair = vim.fn["vimtex#delim#get_surrounding"]("delim_math_modq")
				local open, close = pair[1], pair[2]
				if not open.lnum or not close.lnum then
					break
				end
				local key = open.lnum .. ":" .. open.cnum
				if seen[key] then
					break
				end
				seen[key] = true
				if needs_size(open, close) then
					table.insert(edits, { row = open.lnum - 1, col = open.cnum - 1, text = "\\left" })
					table.insert(edits, { row = close.lnum - 1, col = close.cnum - 1, text = "\\right" })
				end
				if open.cnum > 1 then
					vim.api.nvim_win_set_cursor(0, { open.lnum, open.cnum - 2 })
				elseif open.lnum > 1 then
					vim.api.nvim_win_set_cursor(0, { open.lnum - 1, #vim.fn.getline(open.lnum - 1) })
				else
					break
				end
			end
		end
	end)
	vim.api.nvim_win_set_cursor(0, cursor)
	if not ok then
		error(err)
	end
	if #edits == 0 then
		return
	end
	table.sort(edits, function(a, b)
		return a.row > b.row or (a.row == b.row and a.col > b.col)
	end)
	local mark = vim.api.nvim_buf_set_extmark(0, ns, cursor[1] - 1, cursor[2], { right_gravity = true })
	for _, edit in ipairs(edits) do
		pcall(vim.cmd, "undojoin") -- Desfazer acompanha a edição que provocou o ajuste.
		vim.api.nvim_buf_set_text(0, edit.row, edit.col, edit.row, edit.col, { edit.text })
	end
	local pos = vim.api.nvim_buf_get_extmark_by_id(0, ns, mark, {})
	vim.api.nvim_buf_del_extmark(0, ns, mark)
	vim.api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] })
end

function M.setup()
	local group = vim.api.nvim_create_augroup("TexAutoSize", { clear = true })
	local pending = false
	local function request()
		if vim.bo.filetype ~= "tex" or pending then
			return
		end
		pending = true
		local buf = vim.api.nvim_get_current_buf()
		-- Aguarda a expansão terminar antes de tocar nos delimitadores externos.
		vim.schedule(function()
			pending = false
			if vim.api.nvim_get_current_buf() == buf then
				M.update()
			end
		end)
	end
	vim.api.nvim_create_autocmd(
		{ "TextChangedI", "TextChangedP", "InsertLeave" },
		{ group = group, callback = request }
	)
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = { "LuasnipInsertNodeEnter", "LuasnipSnippetEnter" },
		callback = request,
	})
end

return M
