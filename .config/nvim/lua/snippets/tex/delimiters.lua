local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local in_mathzone = tex.in_mathzone

return {

	-- =================================================================
	-- BRACKETS & DELIMITERS
	-- =================================================================
	-- avg: Valor médio entre delimitadores angulares.
	s(
		{ trig = "avg", snippetType = "autosnippet" },
		fmta("\\langle <> \\rangle <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- norm: Norma; requer comando \norm definido no preâmbulo ou por pacote.
	s(
		{ trig = "norm", snippetType = "autosnippet", priority = 1 },
		fmta("\\norm{<>} <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- abs: Valor absoluto; requer comando \abs definido no preâmbulo ou por pacote.
	s(
		{ trig = "abs", snippetType = "autosnippet", priority = 1 },
		fmta("\\abs{<>} <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- ceil: Teto entre delimitadores de arredondamento para cima.
	s(
		{ trig = "ceil", snippetType = "autosnippet" },
		fmta("\\lceil <> \\rceil <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- floor: Piso entre delimitadores de arredondamento para baixo.
	s(
		{ trig = "floor", snippetType = "autosnippet" },
		fmta("\\lfloor <> \\rfloor <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- mod: Módulo entre barras.
	s({ trig = "mod", snippetType = "autosnippet" }, fmta("|<>|<>", { i(1), i(2) }), { condition = in_mathzone }),
	-- lr(: Parênteses com tamanho automático.
	s(
		{ trig = "lr(", snippetType = "autosnippet" },
		fmta("\\left( <> \\right) <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- lr{: Chaves com tamanho automático.
	s(
		{ trig = "lr{", snippetType = "autosnippet" },
		fmta("\\left\\{ <> \\right\\} <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- lr[: Colchetes com tamanho automático.
	s(
		{ trig = "lr[", snippetType = "autosnippet" },
		fmta("\\left[ <> \\right] <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- lr|: Barras com tamanho automático.
	s(
		{ trig = "lr|", snippetType = "autosnippet" },
		fmta("\\left| <> \\right| <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- lra: Delimitadores angulares com tamanho automático.
	s(
		{ trig = "lra", snippetType = "autosnippet" },
		fmta("\\left\\langle <> \\right\\rangle <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
}
