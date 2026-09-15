local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local in_mathzone = tex.in_mathzone
local in_text = tex.in_text

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	-- =================================================================
	-- MATRIX & ENVIRONMENTS
	-- =================================================================
	-- pmat: Matriz entre parênteses (amsmath).
	s(
		{ trig = "pmat", snippetType = "autosnippet" },
		fmta("\\begin{pmatrix}\n\t<>\n\\end{pmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	-- bmat: Matriz entre colchetes (amsmath).
	s(
		{ trig = "bmat", snippetType = "autosnippet" },
		fmta("\\begin{bmatrix}\n\t<>\n\\end{bmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	-- Bmat: Matriz entre chaves (amsmath).
	s(
		{ trig = "Bmat", snippetType = "autosnippet" },
		fmta("\\begin{Bmatrix}\n\t<>\n\\end{Bmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	-- vmat: Determinante entre barras (amsmath).
	s(
		{ trig = "vmat", snippetType = "autosnippet" },
		fmta("\\begin{vmatrix}\n\t<>\n\\end{vmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	-- align: Equações alinhadas e numeradas; inicia fora do modo matemático (amsmath).
	s(

		{ trig = "align", snippetType = "autosnippet" },
		fmta("\\begin{align}\n\t<>\n\\end{align}", { i(1) }),
		{ condition = in_text }
	),
	-- array: Arranjo com especificação editável das colunas e conteúdo.
	s(
		{ trig = "array", snippetType = "autosnippet" },
		fmta("\\begin{array}{<>}\n\t<>\n\\end{array}", { i(1, "cc"), i(2) }),
		{ condition = in_mathzone }
	),

	-- Matriz Identidade N x N (Função Dinâmica)
	-- iden([1-9]): Matriz identidade de ordem 1 a 9; exemplo: iden3.
	s(
		{ trig = "iden([1-9])", regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
        \begin{pmatrix}
        <>
        \end{pmatrix}
        ]],
			{
				f(function(_, snip)
					-- Captura o número digitado e converte para inteiro
					local n = tonumber(snip.captures[1])
					local lines = {}
					for r = 1, n do
						local row = {}
						for c = 1, n do
							-- Insere 1 na diagonal principal e 0 no resto
							table.insert(row, r == c and "1" or "0")
						end
						-- Junta os números da linha com " & "
						local line = table.concat(row, " & ")
						-- Adiciona a quebra de linha do LaTeX (\\), exceto na última linha
						if r < n then
							line = line .. " \\\\"
						end
						table.insert(lines, line)
					end
					-- Retornar uma tabela de strings num nó de função
					-- faz com que o LuaSnip as interprete como múltiplas linhas
					return lines
				end),
			}
		),
		{ condition = in_mathzone }
	),

	-- null([1-9]): Matriz nula quadrada de ordem 1 a 9; exemplo: null3.
	s(
		{ trig = "null([1-9])", regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
        \begin{pmatrix}
        <>
        \end{pmatrix}
        ]],
			{
				f(function(_, snip)
					local n = tonumber(snip.captures[1])
					local lines = {}

					for r = 1, n do
						local row = {}
						for _ = 1, n do
							-- Insere apenas "0" em todas as posições
							table.insert(row, "0")
						end

						local line = table.concat(row, " & ")

						if r < n then
							line = line .. " \\\\"
						end

						table.insert(lines, line)
					end

					return lines
				end),
			}
		),
		{ condition = in_mathzone }
	),
	-- =================================================================
	-- MODE ENVIROMENTS & SETUP
	-- =================================================================

	-- mm: Matemática em linha; funciona também no início da linha.
	s({ trig = "mm", snippetType = "autosnippet" }, fmta("$<>$", { i(1) }), { condition = in_text }),

	-- nn: Matemática em destaque com \[ e \], preservando o texto anterior.
	s({ trig = "nn", snippetType = "autosnippet" }, fmta("\\[\n\t<>\n\\]", { i(1) }), { condition = in_text }),

	-- env: Ambiente genérico no início da linha; repete o nome no fechamento.
	s(
		{ trig = "env", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{<>}
    <>
    \end{<>}
    ]],
			{ i(1), i(2), rep(1) },
			{ trim_empty = false }
		),
		{
			-- Combinamos a sua condição `in_text` com a `line_begin`
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),

	-- edef: Ambiente definicao; requer definição no preâmbulo.
	s(
		{ trig = "edef", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{definicao}
    <>
    \end{definicao}
    ]],
			{ i(1) },
			{ trim_empty = false }
		),
		{
			-- Combinamos a sua condição `in_text` com a `line_begin`
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),

	-- eexe: Ambiente exemplo; requer definição no preâmbulo.
	s(
		{ trig = "eexe", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{exemplo}
    <>
    \end{exemplo}
    ]],
			{ i(1) },
			{ trim_empty = false }
		),
		{
			-- Combinamos a sua condição `in_text` com a `line_begin`
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),

	-- eteo: Teorema e demonstração; requer ambiente teorema e proof.
	s(
		{ trig = "eteo", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{teorema}
    <>
    \end{teorema}
    \begin{proof}
    <>
    \end{proof}
    ]],
			{ i(1), i(2) },
			{ trim_empty = false }
		),
		{
			-- Combinamos a sua condição `in_text` com a `line_begin`
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),

	-- ecor: Corolário e demonstração; requer ambiente corolario e proof.
	s(
		{ trig = "ecor", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{corolario}
    <>
    \end{corolario}
    \begin{proof}
    <>
    \end{proof}
    ]],
			{ i(1), i(2) },
			{ trim_empty = false }
		),
		{
			-- Combinamos a sua condição `in_text` com a `line_begin`
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),

	-- elem: Lema e demonstração; requer ambiente lema e proof.
	s(
		{ trig = "elem", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{lema}
    <>
    \end{lema}
    \begin{proof}
    <>
    \end{proof}
    ]],
			{ i(1), i(2) },
			{ trim_empty = false }
		),
		{
			-- Combinamos a sua condição `in_text` com a `line_begin`
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),

	-- epro: Proposição e demonstração; requer ambiente proposicao e proof.
	s(
		{ trig = "epro", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[

    \begin{proposicao}
    <>
    \end{proposicao}
    \begin{proof}
    <>
    \end{proof}
    ]],
			{ i(1), i(2) },
			{ trim_empty = false }
		),
		{
			condition = function(...)
				return in_text() and line_begin(...)
			end,
		}
	),
}
