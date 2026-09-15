local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local in_mathzone = tex.in_mathzone

return {
	-- =================================================================
	-- SYMBOLS & OPERATORS
	-- =================================================================
	-- lac: Seta de ação com dois argumentos; requer macro personalizada \actionarrow.
	s(
		{ trig = "lac", snippetType = "autosnippet" },
		fmta("\\actionarrow{<>}{<>} <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
	-- ooo: Insere \infty.
	s({ trig = "ooo", snippetType = "autosnippet" }, { t("\\infty") }, { condition = in_mathzone }),
	-- sum: Insere \sum.
	s({ trig = "sum", snippetType = "autosnippet" }, { t("\\sum") }, { condition = in_mathzone }),
	-- prod: Insere \prod.
	s({ trig = "prod", snippetType = "autosnippet" }, { t("\\prod") }, { condition = in_mathzone }),
	-- \sum: Somatório com índice e limites editáveis; expanda com Tab.
	s(
		{ trig = "\\sum" },
		fmta("\\sum_{<>={<>}}^{<>} <>", { i(1, "i"), i(2, "1"), i(3, "N"), i(4) }),
		{ condition = in_mathzone }
	),
	-- \prod: Produtório com índice e limites editáveis; expanda com Tab.
	s(
		{ trig = "\\prod" },
		fmta("\\prod_{<>={<>}}^{<>} <>", { i(1, "i"), i(2, "1"), i(3, "N"), i(4) }),
		{ condition = in_mathzone }
	),
	-- lim: Limite com variável, destino e expressão editáveis.
	s(
		{ trig = "lim", snippetType = "autosnippet" },
		fmta("\\lim_{ <> \\to <> } <>", { i(1, "n"), i(2, "\\infty"), i(3) }),
		{ condition = in_mathzone }
	),
	-- +-: Insere \pm.
	s({ trig = "+-", wordTrig = false, snippetType = "autosnippet" }, { t("\\pm") }, { condition = in_mathzone }),
	-- -+: Insere \mp.
	s({ trig = "-+", wordTrig = false, snippetType = "autosnippet" }, { t("\\mp") }, { condition = in_mathzone }),
	-- ...: Insere \dots.
	s({ trig = "...", wordTrig = false, snippetType = "autosnippet" }, { t("\\dots") }, { condition = in_mathzone }),
	-- div: Insere \vec{\nabla} \cdot.
	s({ trig = "div", snippetType = "autosnippet" }, { t("\\vec{\\nabla} \\cdot ") }, { condition = in_mathzone }),
	-- rot: Insere \vec{\nabla} \times.
	s({ trig = "rot", snippetType = "autosnippet" }, { t("\\vec{\\nabla} \\times ") }, { condition = in_mathzone }),
	-- nabl: Insere \nabla.
	s({ trig = "nabl", snippetType = "autosnippet" }, { t("\\nabla") }, { condition = in_mathzone }),
	-- del: Insere \vec{\nabla}.
	s({ trig = "del", snippetType = "autosnippet" }, { t("\\vec{\\nabla}") }, { condition = in_mathzone }),
	-- xx: Insere \times.
	s({ trig = "xx", snippetType = "autosnippet" }, { t("\\times") }, { condition = in_mathzone }),
	-- **: Insere \cdot.
	s({ trig = "**", wordTrig = false, snippetType = "autosnippet" }, { t("\\cdot") }, { condition = in_mathzone }),
	-- para: Insere \parallel.
	s({ trig = "para", snippetType = "autosnippet" }, { t("\\parallel") }, { condition = in_mathzone }),

	-- ===: Insere \equiv.
	s({ trig = "===", wordTrig = false, snippetType = "autosnippet" }, { t("\\equiv") }, { condition = in_mathzone }),
	-- !=: Insere \neq.
	s({ trig = "!=", wordTrig = false, snippetType = "autosnippet" }, { t("\\neq") }, { condition = in_mathzone }),
	-- >=: Insere \geq.
	s({ trig = ">=", wordTrig = false, snippetType = "autosnippet" }, { t("\\geq") }, { condition = in_mathzone }),
	-- <=: Insere \leq.
	s({ trig = "<=", wordTrig = false, snippetType = "autosnippet" }, { t("\\leq") }, { condition = in_mathzone }),
	-- >>: Insere \gg.
	s({ trig = ">>", wordTrig = false, snippetType = "autosnippet" }, { t("\\gg") }, { condition = in_mathzone }),
	-- <<: Insere \ll.
	s({ trig = "<<", wordTrig = false, snippetType = "autosnippet" }, { t("\\ll") }, { condition = in_mathzone }),
	-- simm: Insere \sim.
	s({ trig = "simm", snippetType = "autosnippet" }, { t("\\sim") }, { condition = in_mathzone }),
	-- sim=: Insere \simeq.
	s({ trig = "sim=", snippetType = "autosnippet" }, { t("\\simeq") }, { condition = in_mathzone }),
	-- prop: Insere \propto.
	s({ trig = "prop", snippetType = "autosnippet" }, { t("\\propto") }, { condition = in_mathzone }),

	-- <->: Insere \leftrightarrow.
	s(
		{ trig = "<->", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\leftrightarrow ") },
		{ condition = in_mathzone }
	),
	-- to: Insere \to.
	s({ trig = "to", snippetType = "autosnippet" }, { t("\\to") }, { condition = in_mathzone }),
	-- mapsto: Insere \mapsto.
	s({ trig = "mapsto", snippetType = "autosnippet" }, { t("\\mapsto ") }, { condition = in_mathzone }),
	-- =>: Insere \implies.
	s({ trig = "=>", wordTrig = false, snippetType = "autosnippet" }, { t("\\implies") }, { condition = in_mathzone }),
	-- =<: Insere \impliedby.
	s(
		{ trig = "=<", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\impliedby") },
		{ condition = in_mathzone }
	),

	-- and: Insere \cap.
	s({ trig = "and", snippetType = "autosnippet" }, { t("\\cap") }, { condition = in_mathzone }),
	-- orr: Insere \cup.
	s({ trig = "orr", snippetType = "autosnippet" }, { t("\\cup") }, { condition = in_mathzone }),
	-- inn: Insere \in.
	s({ trig = "inn", snippetType = "autosnippet" }, { t("\\in") }, { condition = in_mathzone }),
	-- notin: Insere \not\in.
	s({ trig = "notin", snippetType = "autosnippet" }, { t("\\not\\in") }, { condition = in_mathzone }),
	-- \\\: Insere \setminus.
	s({ trig = "\\\\\\", snippetType = "autosnippet" }, { t("\\setminus") }, { condition = in_mathzone }),
	-- ss: Insere \subset.
	s({ trig = "ss", snippetType = "autosnippet" }, { t("\\subset") }, { condition = in_mathzone }),
	-- ess: Insere \subseteq.
	s({ trig = "ess", snippetType = "autosnippet" }, { t("\\subseteq") }, { condition = in_mathzone }),
	-- oss: Insere \opsubset; requer macro personalizada no preâmbulo.
	s({ trig = "oss", snippetType = "autosnippet" }, { t("\\opsubset") }, { condition = in_mathzone }),
	-- fss: Insere \fcsubset; requer macro personalizada no preâmbulo.
	s({ trig = "fss", snippetType = "autosnippet" }, { t("\\fcsubset") }, { condition = in_mathzone }),
	-- sub=: Insere \subseteq.
	s({ trig = "sub=", snippetType = "autosnippet" }, { t("\\subseteq") }, { condition = in_mathzone }),
	-- sup=: Insere \supseteq.
	s({ trig = "sup=", snippetType = "autosnippet" }, { t("\\supseteq") }, { condition = in_mathzone }),
	-- eset: Insere \emptyset.
	s({ trig = "eset", snippetType = "autosnippet" }, { t("\\emptyset") }, { condition = in_mathzone }),
	-- set: Conjunto com elementos editáveis.
	s({ trig = "set", snippetType = "autosnippet" }, fmta("\\{ <> \\}<>", { i(1), i(2) }), { condition = in_mathzone }),
	-- exists: Insere \exists.
	s(
		{ trig = "exists", snippetType = "autosnippet", priority = 1100 },
		{ t("\\exists") },
		{ condition = in_mathzone }
	),

	-- Conjuntos / Símbolos Mathbb
	-- LL: Insere \mathcal{L}.
	s({ trig = "LL", snippetType = "autosnippet" }, { t("\\mathcal{L}") }, { condition = in_mathzone }),
	-- HH: Insere \mathcal{H}.
	s({ trig = "HH", snippetType = "autosnippet" }, { t("\\mathcal{H}") }, { condition = in_mathzone }),
	-- CC: Insere \mathbb{C}.
	s({ trig = "CC", snippetType = "autosnippet" }, { t("\\mathbb{C}") }, { condition = in_mathzone }),
	-- RR: Insere \mathbb{R}.
	s({ trig = "RR", snippetType = "autosnippet" }, { t("\\mathbb{R}") }, { condition = in_mathzone }),
	-- ZZ: Insere \mathbb{Z}.
	s({ trig = "ZZ", snippetType = "autosnippet" }, { t("\\mathbb{Z}") }, { condition = in_mathzone }),
	-- NN: Insere \mathbb{N}.
	s({ trig = "NN", snippetType = "autosnippet" }, { t("\\mathbb{N}") }, { condition = in_mathzone }),
	-- SS: Insere \mathbb{S}.
	s({ trig = "SS", snippetType = "autosnippet" }, { t("\\mathbb{S}") }, { condition = in_mathzone }),
	-- VV: Insere \mathbb{V}.
	s({ trig = "VV", snippetType = "autosnippet" }, { t("\\mathbb{V}") }, { condition = in_mathzone }),
	-- WW: Insere \mathbb{W}.
	s({ trig = "WW", snippetType = "autosnippet" }, { t("\\mathbb{W}") }, { condition = in_mathzone }),
	-- QQ: Insere \mathcal{Q}.
	s({ trig = "QQ", snippetType = "autosnippet" }, { t("\\mathcal{Q}") }, { condition = in_mathzone }),
	-- MM: Insere \mathcal{M}.
	s({ trig = "MM", snippetType = "autosnippet" }, { t("\\mathcal{M}") }, { condition = in_mathzone }),
}
