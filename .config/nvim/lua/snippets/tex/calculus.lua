local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local in_mathzone = tex.in_mathzone

return {
	-- =================================================================
	-- DERIVATIVES AND INTEGRALS
	-- =================================================================
	-- par: Derivada parcial com função e variável editáveis; expanda com Tab.
	s(
		{ trig = "par" },
		fmta("\\frac{ \\partial <> }{ \\partial <> } <>", { i(1, "y"), i(2, "x"), i(3) }),
		{ condition = in_mathzone }
	),
	-- pa([A-Za-z])([A-Za-z]): Derivada parcial de duas letras capturadas (payx); expanda com Tab.
	s(
		{ trig = "pa([A-Za-z])([A-Za-z])", regTrig = true },
		f(function(_, p)
			return "\\frac{ \\partial " .. p.snippet.captures[1] .. " }{ \\partial " .. p.snippet.captures[2] .. " } "
		end),
		{ condition = in_mathzone }
	),

	-- der: Derivada ordinária com função e variável editáveis; expanda com Tab.
	s({ trig = "der" }, fmta("\\frac{ d <> }{ d <> } <>", { i(1, "y"), i(2, "x"), i(3) }), { condition = in_mathzone }),
	-- de([A-Za-z])([A-Za-z]): Derivada ordinária de duas letras capturadas (deyx); expanda com Tab.
	s(
		{ trig = "de([A-Za-z])([A-Za-z])", regTrig = true },
		f(function(_, p)
			return "\\frac{ d " .. p.snippet.captures[1] .. " }{ d " .. p.snippet.captures[2] .. " } "
		end),
		{ condition = in_mathzone }
	),

	-- ddt: Operador de derivada em relação ao tempo.
	s({ trig = "ddt", snippetType = "autosnippet" }, { t("\\frac{d}{dt} ") }, { condition = in_mathzone }),

	-- int: Insere o símbolo de integral; Tab acrescenta integrando e diferencial.
	s({ trig = "int", snippetType = "autosnippet" }, { t("\\int") }, { condition = in_mathzone }),
	-- \int: Completa a integral com integrando e variável de integração; use Tab.
	s({ trig = "\\int" }, fmta("\\int <> \\, d<> <>", { i(1), i(2, "x"), i(3) }), { condition = in_mathzone }),
	-- dint: Integral definida com limites, integrando e diferencial.
	s(
		{ trig = "dint", snippetType = "autosnippet" },
		fmta("\\int_{<>}^{<>} <> \\, d<> <>", { i(1, "0"), i(2, "1"), i(3), i(4, "x"), i(5) }),
		{ condition = in_mathzone }
	),
	-- oint: Insere \oint.
	s({ trig = "oint", snippetType = "autosnippet" }, { t("\\oint") }, { condition = in_mathzone }),
	-- oiint: Insere \oiint. Requer pacote que forneça esse símbolo (como esint).
	s({ trig = "oiint", snippetType = "autosnippet" }, { t("\\oiint") }, { condition = in_mathzone }),
	-- oiiint: Insere \oiiint. Requer pacote que forneça esse símbolo (como esint).
	s({ trig = "oiiint", snippetType = "autosnippet" }, { t("\\oiiint") }, { condition = in_mathzone }),
	-- iint: Insere \iint.
	s({ trig = "iint", snippetType = "autosnippet" }, { t("\\iint") }, { condition = in_mathzone }),
	-- iiint: Insere \iiint.
	s({ trig = "iiint", snippetType = "autosnippet" }, { t("\\iiint") }, { condition = in_mathzone }),
	-- oinf: Integral de zero a infinito.
	s(
		{ trig = "oinf", snippetType = "autosnippet" },
		fmta("\\int_{0}^{\\infty} <> \\, d<> <>", { i(1), i(2, "x"), i(3) }),
		{ condition = in_mathzone }
	),
	-- infi: Integral de menos infinito a infinito.
	s(
		{ trig = "infi", snippetType = "autosnippet" },
		fmta("\\int_{-\\infty}^{\\infty} <> \\, d<> <>", { i(1), i(2, "x"), i(3) }),
		{ condition = in_mathzone }
	),
	-- kron: Delta de Kronecker com índices editáveis.
	s(
		{ trig = "kron", snippetType = "autosnippet" },
		fmta("\\delta_{<>}^{<>} <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),

	-- tayl: Expansão de Taylor até segunda ordem, com resto em lambda e reticências.
	s(
		{ trig = "tayl", snippetType = "autosnippet" },
		fmta(
			"<>(<> + <>) = <>(<>) + <>'(<>)<> + <>''(\\lambda) \\frac{<>^{2}}{2!} + \\dots<>",
			{ i(1, "f"), i(2, "x"), i(3, "h"), rep(1), rep(2), rep(1), rep(2), rep(3), rep(1), rep(3), i(4) }
		),
		{ condition = in_mathzone }
	),
}
