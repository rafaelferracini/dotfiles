local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local in_mathzone = tex.in_mathzone

return {
	-- =================================================================
	-- PHYSICS & QUANTUM MECHANICS
	-- =================================================================
	-- coul: Insere \frac{1}{4 \pi \epsilon_0}.
	s(
		{ trig = "coul", snippetType = "autosnippet" },
		{ t("\\frac{1}{4 \\pi \\epsilon_0}") },
		{ condition = in_mathzone }
	),
	-- kbt: Insere k_{B}T.
	s({ trig = "kbt", snippetType = "autosnippet" }, { t("k_{B}T") }, { condition = in_mathzone }),
	-- msun: Insere M_{\odot}.
	s({ trig = "msun", snippetType = "autosnippet" }, { t("M_{\\odot}") }, { condition = in_mathzone }),
	-- ri: Insere \vec{r}_{i}.
	s({ trig = "ri", snippetType = "autosnippet" }, { t("\\vec{r}_{i}") }, { condition = in_mathzone }),
	-- dri: Insere \dot{\vec{r}}_{i}.
	s({ trig = "dri", snippetType = "autosnippet" }, { t("\\dot{\\vec{r}}_{i}") }, { condition = in_mathzone }),
	-- vi: Insere \vec{v}_{i}.
	s({ trig = "vi", snippetType = "autosnippet" }, { t("\\vec{v}_{i}") }, { condition = in_mathzone }),
	-- qk: Insere q_{k}.
	s({ trig = "qk", snippetType = "autosnippet" }, { t("q_{k}") }, { condition = in_mathzone }),
	-- Ql: Insere Q_{l}.
	s({ trig = "Ql", snippetType = "autosnippet" }, { t("Q_{l}") }, { condition = in_mathzone }),
	-- dqk: Insere \dot{q}_{k}.
	s({ trig = "dqk", snippetType = "autosnippet" }, { t("\\dot{q}_{k}") }, { condition = in_mathzone }),
	-- dQl: Insere \dot{Q}_{l}.
	s({ trig = "dQl", snippetType = "autosnippet" }, { t("\\dot{Q}_{l}") }, { condition = in_mathzone }),
	-- lagrange: Equação de Euler–Lagrange com variáveis editáveis e expressão repetida.
	s(
		{ trig = "lagrange", snippetType = "autosnippet" },
		fmta(
			"\\frac{d}{d<>} \\left( \\frac{ \\partial <> }{ \\partial <> } \\right)- \\frac{ \\partial <> }{ \\partial <> } = 0",
			{ i(1), i(2), i(3), rep(2), i(4) }
		),
		{ condition = in_mathzone }
	),

	-- dag: Insere ^{\dagger}.
	s(
		{ trig = "dag", wordTrig = false, snippetType = "autosnippet" },
		{ t("^{\\dagger}") },
		{ condition = in_mathzone }
	),
	-- o+: Insere \oplus.
	s({ trig = "o+", snippetType = "autosnippet" }, { t("\\oplus ") }, { condition = in_mathzone }),
	-- ox: Insere \otimes.
	s({ trig = "ox", snippetType = "autosnippet" }, { t("\\otimes ") }, { condition = in_mathzone }),
	-- bra: Bra de Dirac; requer macro \bra (por exemplo, pacote braket).
	s({ trig = "bra", snippetType = "autosnippet" }, fmta("\\bra{<>} <>", { i(1), i(2) }), { condition = in_mathzone }),
	-- ket: Ket de Dirac; requer macro \ket (por exemplo, pacote braket).
	s({ trig = "ket", snippetType = "autosnippet" }, fmta("\\ket{<>} <>", { i(1), i(2) }), { condition = in_mathzone }),
	-- brk: Produto interno de Dirac; requer macro \braket compatível com barras.
	s(
		{ trig = "brk", snippetType = "autosnippet" },
		fmta("\\braket{ <> | <> } <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
	-- outer: Projetor: produto de ket e bra do mesmo estado; requer essas macros.
	s(
		{ trig = "outer", snippetType = "autosnippet" },
		fmta("\\ket{<>} \\bra{<>} <>", { i(1, "\\psi"), rep(1), i(2) }),
		{ condition = in_mathzone }
	),
}
