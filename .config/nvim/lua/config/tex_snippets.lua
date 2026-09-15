local ls = require("luasnip")
local M = {}
local literal_triggers = {}

-- O VimTeX identifica matemática, inclusive texto aninhado e comentários.
function M.in_mathzone()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

function M.in_text()
	return not M.in_mathzone() and vim.fn["vimtex#syntax#in_comment"]() == 0
end

-- Impede que comandos digitados por extenso (como \sum) ganhem outra barra.
-- Mantém gatilhos manuais que já incluem a barra e sufixos após comandos.
function M.snippet(context, nodes, opts)
	if not context.regTrig then
		literal_triggers[context.trig] = true
	end
	opts = opts or {}
	local condition = opts.condition
	opts.condition = function(line, matched, captures)
		-- Protege também comandos cujo final coincide com um sufixo: \exists / sts.
		local command = line:match("\\(%a+)$")
		if matched:sub(1, 1) ~= "\\" and command and literal_triggers[command] then
			return false
		end
		local prefix = line:sub(1, #line - #matched)
		if prefix:sub(-1) == "\\" then
			return false
		end
		return not condition or condition(line, matched, captures)
	end
	return ls.snippet(context, nodes, opts)
end

return M
