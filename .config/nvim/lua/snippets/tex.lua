local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- Função auxiliar do VimTeX para verificar se o cursor está num ambiente matemático
local in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local in_text = function()
	return not in_mathzone()
end

return {
	-- =================================================================
	-- MODE ENVIROMENTS & SETUP
	-- =================================================================
	s({ trig = "mm", wordTrig = false, snippetType = "autosnippet" }, fmta("$<>$", { i(1) }), { condition = in_text }),

	s(
		{ trig = "nn", wordTrig = false, snippetType = "autosnippet" },
		fmta("\n$$\n<>\n$$\n", { i(1) }),
		{ condition = in_text }
	),

	s(
		{ trig = "beg", snippetType = "autosnippet" },
		fmta("\\begin{<>}\n\t<>\n\\end{<>}", { i(1), i(2), rep(1) }),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "edef", snippetType = "autosnippet" },
		fmta("\\begin{definicao}\n\t<>\n\\end{definicao}", { i(1) }),
		{ condition = in_text }
	),

	s(
		{ trig = "eexe", snippetType = "autosnippet" },
		fmta("\\begin{exemplo}\n\t<>\n\\end{exemplo}", { i(1) }),
		{ condition = in_text }
	),

	s(
		{ trig = "eteo", snippetType = "autosnippet" },
		fmta("\\begin{teorema}\n\t<>\n\\end{teorema}\n\\begin{proof}\n\t<>\n\\end{proof}", { i(1), i(2) }),
		{ condition = in_text }
	),

	s(
		{ trig = "ecor", snippetType = "autosnippet" },
		fmta("\\begin{corolario}\n\t<>\n\\end{corolario}\n\\begin{proof}\n\t<>\n\\end{proof}", { i(1), i(2) }),
		{ condition = in_text }
	),

	s(
		{ trig = "elema", snippetType = "autosnippet" },
		fmta("\\begin{lema}\n\t<>\n\\end{lema}\n\\begin{proof}\n\t<>\n\\end{proof}", { i(1), i(2) }),
		{ condition = in_text }
	),

	s(
		{ trig = "eprop", snippetType = "autosnippet" },
		fmta("\\begin{proposicao}\n\t<>\n\\end{proposicao}\n\\begin{proof}\n\t<>\n\\end{proof}", { i(1), i(2) }),
		{ condition = in_text }
	),

	s(
		{ trig = "func", snippetType = "autosnippet" },
		fmta("<>: <> \\to <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),

	-- =================================================================
	-- TEXT & SPACING IN MATH
	-- =================================================================
	s(
		{ trig = "text", snippetType = "autosnippet" },
		fmta("\\text{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s({ trig = '"', snippetType = "autosnippet" }, fmta("\\text{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	s({ trig = "quad", snippetType = "autosnippet" }, { t("\\quad ") }, { condition = in_mathzone }),
	s({ trig = "qquad", snippetType = "autosnippet" }, { t("\\quad \\quad ") }, { condition = in_mathzone }),

	-- =================================================================
	-- BASIC OPERATIONS & EXPONENTS
	-- =================================================================
	s({ trig = "sr", snippetType = "autosnippet" }, { t("^{2}") }, { condition = in_mathzone }),
	s({ trig = "cb", snippetType = "autosnippet" }, { t("^{3}") }, { condition = in_mathzone }),
	s({ trig = "rd", snippetType = "autosnippet" }, fmta("^{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	s({ trig = "_", snippetType = "autosnippet" }, fmta("_{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	s({ trig = "sts", snippetType = "autosnippet" }, fmta("_\\text{<>}", { i(1) }), { condition = in_mathzone }),
	s(
		{ trig = "sq", snippetType = "autosnippet" },
		fmta("\\sqrt{ <> }<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "ff", snippetType = "autosnippet" },
		fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
	s({ trig = "ee", snippetType = "autosnippet" }, fmta("e^{ <> }<>", { i(1), i(2) }), { condition = in_mathzone }),
	s({ trig = "invs", snippetType = "autosnippet" }, { t("^{-1}") }, { condition = in_mathzone }),
	s({ trig = "conj", snippetType = "autosnippet" }, { t("^{*}") }, { condition = in_mathzone }),
	s({ trig = "Re", snippetType = "autosnippet" }, { t("\\mathrm{Re}") }, { condition = in_mathzone }),
	s({ trig = "Im", snippetType = "autosnippet" }, { t("\\mathrm{Im}") }, { condition = in_mathzone }),
	s({ trig = "bf", snippetType = "autosnippet" }, fmta("\\mathbf{<>}", { i(1) }), { condition = in_mathzone }),
	s(
		{ trig = "rm", snippetType = "autosnippet" },
		fmta("\\mathrm{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),

	-- Subscritos Automáticos (Regex)
	s(
		{ trig = "([A-Za-z])(%d)", regTrig = true, snippetType = "autosnippet", priority = -1 },
		f(function(_, p)
			return p.snippet.captures[1] .. "_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "([A-Za-z])_(%d%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return p.snippet.captures[1] .. "_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "\\hat{([A-Za-z])}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\hat{" .. p.snippet.captures[1] .. "}_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "\\vec{([A-Za-z])}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\vec{" .. p.snippet.captures[1] .. "}_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "\\mathbf{([A-Za-z])}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\mathbf{" .. p.snippet.captures[1] .. "}_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- Atalhos de Variáveis Frequentes
	s({ trig = "xnn", snippetType = "autosnippet" }, { t("x_{n}") }, { condition = in_mathzone }),
	s({ trig = "\\xii", snippetType = "autosnippet", priority = 1 }, { t("x_{i}") }, { condition = in_mathzone }),
	s({ trig = "xjj", snippetType = "autosnippet" }, { t("x_{j}") }, { condition = in_mathzone }),
	s({ trig = "xp1", snippetType = "autosnippet" }, { t("x_{n+1}") }, { condition = in_mathzone }),
	s({ trig = "ynn", snippetType = "autosnippet" }, { t("y_{n}") }, { condition = in_mathzone }),
	s({ trig = "yii", snippetType = "autosnippet" }, { t("y_{i}") }, { condition = in_mathzone }),
	s({ trig = "yjj", snippetType = "autosnippet" }, { t("y_{j}") }, { condition = in_mathzone }),

	-- =================================================================
	-- LINEAR ALGEBRA & ACCENTS
	-- =================================================================
	s({ trig = "trace", snippetType = "autosnippet" }, { t("\\mathrm{Tr}") }, { condition = in_mathzone }),
	s(
		{ trig = "basis", snippetType = "autosnippet" },
		{ t("\\{ e_{i} \\}_{i = 0, 1, 2, 3}") },
		{ condition = in_mathzone }
	),
	s(
		{ trig = "tns", snippetType = "autosnippet" },
		fmta("\\tensor{<>}{<>}", { i(1), i(2) }),
		{ condition = in_mathzone }
	),

	-- Diacríticos
	s(
		{ trig = "([a-zA-Z])hat", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\hat{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])bar", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\bar{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])dot", regTrig = true, snippetType = "autosnippet", priority = -1 },
		f(function(_, p)
			return "\\dot{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])ddot", regTrig = true, snippetType = "autosnippet", priority = 1 },
		f(function(_, p)
			return "\\ddot{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])tilde", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\tilde{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])und", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\underline{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])vec", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\vec{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z]),\\.", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\mathbf{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "([a-zA-Z])\\.,", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\mathbf{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s({ trig = "hat", snippetType = "autosnippet" }, fmta("\\hat{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	s({ trig = "bar", snippetType = "autosnippet" }, fmta("\\bar{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	s(
		{ trig = "dot", snippetType = "autosnippet", priority = -1 },
		fmta("\\dot{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "ddot", snippetType = "autosnippet" },
		fmta("\\ddot{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s({ trig = "cdot", snippetType = "autosnippet" }, { t("\\cdot") }, { condition = in_mathzone }),
	s(
		{ trig = "tilde", snippetType = "autosnippet" },
		fmta("\\tilde{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "und", snippetType = "autosnippet" },
		fmta("\\underline{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s({ trig = "vec", snippetType = "autosnippet" }, fmta("\\vec{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),

	-- =================================================================
	-- SYMBOLS & OPERATORS
	-- =================================================================
	s(
		{ trig = "lac", snippetType = "autosnippet" },
		fmta("\\actionarrow{<>}{<>} <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
	s({ trig = "ooo", snippetType = "autosnippet" }, { t("\\infty") }, { condition = in_mathzone }),
	s({ trig = "sum", snippetType = "autosnippet" }, { t("\\sum") }, { condition = in_mathzone }),
	s({ trig = "prod", snippetType = "autosnippet" }, { t("\\prod") }, { condition = in_mathzone }),
	s(
		{ trig = "\\sum" },
		fmta("\\sum_{<>={<>}}^{<>} <>", { i(1, "i"), i(2, "1"), i(3, "N"), i(4) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "\\prod" },
		fmta("\\prod_{<>={<>}}^{<>} <>", { i(1, "i"), i(2, "1"), i(3, "N"), i(4) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "lim", snippetType = "autosnippet" },
		fmta("\\lim_{ <> \\to <> } <>", { i(1, "n"), i(2, "\\infty"), i(3) }),
		{ condition = in_mathzone }
	),
	s({ trig = "+-", snippetType = "autosnippet" }, { t("\\pm") }, { condition = in_mathzone }),
	s({ trig = "-+", snippetType = "autosnippet" }, { t("\\mp") }, { condition = in_mathzone }),
	s({ trig = "...", snippetType = "autosnippet" }, { t("\\dots") }, { condition = in_mathzone }),
	s({ trig = "div", snippetType = "autosnippet" }, { t("\\vec{\\nabla} \\cdot ") }, { condition = in_mathzone }),
	s({ trig = "rot", snippetType = "autosnippet" }, { t("\\vec{\\nabla} \\times ") }, { condition = in_mathzone }),
	s({ trig = "nabl", snippetType = "autosnippet" }, { t("\\nabla") }, { condition = in_mathzone }),
	s({ trig = "del", snippetType = "autosnippet" }, { t("\\vec{\\nabla}") }, { condition = in_mathzone }),
	s({ trig = "xx", snippetType = "autosnippet" }, { t("\\times") }, { condition = in_mathzone }),
	s({ trig = "**", snippetType = "autosnippet" }, { t("\\cdot") }, { condition = in_mathzone }),
	s({ trig = "para", snippetType = "autosnippet" }, { t("\\parallel") }, { condition = in_mathzone }),

	s({ trig = "===", snippetType = "autosnippet" }, { t("\\equiv") }, { condition = in_mathzone }),
	s({ trig = "!=", snippetType = "autosnippet" }, { t("\\neq") }, { condition = in_mathzone }),
	s({ trig = ">=", snippetType = "autosnippet" }, { t("\\geq") }, { condition = in_mathzone }),
	s({ trig = "<=", snippetType = "autosnippet" }, { t("\\leq") }, { condition = in_mathzone }),
	s({ trig = ">>", snippetType = "autosnippet" }, { t("\\gg") }, { condition = in_mathzone }),
	s({ trig = "<<", snippetType = "autosnippet" }, { t("\\ll") }, { condition = in_mathzone }),
	s({ trig = "simm", snippetType = "autosnippet" }, { t("\\sim") }, { condition = in_mathzone }),
	s({ trig = "sim=", snippetType = "autosnippet" }, { t("\\simeq") }, { condition = in_mathzone }),
	s({ trig = "prop", snippetType = "autosnippet" }, { t("\\propto") }, { condition = in_mathzone }),

	s({ trig = "<->", snippetType = "autosnippet" }, { t("\\leftrightarrow ") }, { condition = in_mathzone }),
	s({ trig = "to", snippetType = "autosnippet" }, { t("\\to") }, { condition = in_mathzone }),
	s({ trig = "maps\\to ", snippetType = "autosnippet" }, { t("\\mapsto ") }, { condition = in_mathzone }),
	s({ trig = "=>", snippetType = "autosnippet" }, { t("\\implies") }, { condition = in_mathzone }),
	s({ trig = "=<", snippetType = "autosnippet" }, { t("\\impliedby") }, { condition = in_mathzone }),

	s({ trig = "and", snippetType = "autosnippet" }, { t("\\cap") }, { condition = in_mathzone }),
	s({ trig = "orr", snippetType = "autosnippet" }, { t("\\cup") }, { condition = in_mathzone }),
	s({ trig = "inn", snippetType = "autosnippet" }, { t("\\in") }, { condition = in_mathzone }),
	s({ trig = "notin", snippetType = "autosnippet" }, { t("\\not\\in") }, { condition = in_mathzone }),
	s({ trig = "\\\\\\", snippetType = "autosnippet" }, { t("\\setminus") }, { condition = in_mathzone }),
	s({ trig = "ss", snippetType = "autosnippet" }, { t("\\subset") }, { condition = in_mathzone }),
	s({ trig = "ess", snippetType = "autosnippet" }, { t("\\subseteq") }, { condition = in_mathzone }),
	s({ trig = "oss", snippetType = "autosnippet" }, { t("\\opsubset") }, { condition = in_mathzone }),
	s({ trig = "fss", snippetType = "autosnippet" }, { t("\\fcsubset") }, { condition = in_mathzone }),
	s({ trig = "sub=", snippetType = "autosnippet" }, { t("\\subseteq") }, { condition = in_mathzone }),
	s({ trig = "sup=", snippetType = "autosnippet" }, { t("\\supseteq") }, { condition = in_mathzone }),
	s({ trig = "eset", snippetType = "autosnippet" }, { t("\\emptyset") }, { condition = in_mathzone }),
	s({ trig = "set", snippetType = "autosnippet" }, fmta("\\{ <> \\}<>", { i(1), i(2) }), { condition = in_mathzone }),
	s(
		{ trig = "e\\xi sts", snippetType = "autosnippet", priority = 1 },
		{ t("\\exists") },
		{ condition = in_mathzone }
	),

	-- Conjuntos / Símbolos Mathbb
	s({ trig = "LL", snippetType = "autosnippet" }, { t("\\mathcal{L}") }, { condition = in_mathzone }),
	s({ trig = "HH", snippetType = "autosnippet" }, { t("\\mathcal{H}") }, { condition = in_mathzone }),
	s({ trig = "CC", snippetType = "autosnippet" }, { t("\\mathbb{C}") }, { condition = in_mathzone }),
	s({ trig = "RR", snippetType = "autosnippet" }, { t("\\mathbb{R}") }, { condition = in_mathzone }),
	s({ trig = "ZZ", snippetType = "autosnippet" }, { t("\\mathbb{Z}") }, { condition = in_mathzone }),
	s({ trig = "NN", snippetType = "autosnippet" }, { t("\\mathbb{N}") }, { condition = in_mathzone }),
	s({ trig = "SS", snippetType = "autosnippet" }, { t("\\mathbb{S}") }, { condition = in_mathzone }),
	s({ trig = "VV", snippetType = "autosnippet" }, { t("\\mathbb{V}") }, { condition = in_mathzone }),
	s({ trig = "WW", snippetType = "autosnippet" }, { t("\\mathbb{W}") }, { condition = in_mathzone }),
	s({ trig = "QQ", snippetType = "autosnippet" }, { t("\\mathcal{Q}") }, { condition = in_mathzone }),
	s({ trig = "MM", snippetType = "autosnippet" }, { t("\\mathcal{M}") }, { condition = in_mathzone }),

	-- =================================================================
	-- DERIVATIVES AND INTEGRALS
	-- =================================================================
	s(
		{ trig = "par" },
		fmta("\\frac{ \\partial <> }{ \\partial <> } <>", { i(1, "y"), i(2, "x"), i(3) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "pa([A-Za-z])([A-Za-z])", regTrig = true },
		f(function(_, p)
			return "\\frac{ \\partial " .. p.snippet.captures[1] .. " }{ \\partial " .. p.snippet.captures[2] .. " } "
		end),
		{ condition = in_mathzone }
	),

	s({ trig = "der" }, fmta("\\frac{ d <> }{ d <> } <>", { i(1, "y"), i(2, "x"), i(3) }), { condition = in_mathzone }),
	s(
		{ trig = "de([A-Za-z])([A-Za-z])", regTrig = true },
		f(function(_, p)
			return "\\frac{ d " .. p.snippet.captures[1] .. " }{ d " .. p.snippet.captures[2] .. " } "
		end),
		{ condition = in_mathzone }
	),

	s({ trig = "ddt", snippetType = "autosnippet" }, { t("\\frac{d}{dt} ") }, { condition = in_mathzone }),

	s(
		{ trig = "([^\\\\])int", regTrig = true, snippetType = "autosnippet", priority = -1 },
		f(function(_, p)
			return p.snippet.captures[1] .. "\\int"
		end),
		{ condition = in_mathzone }
	),
	s({ trig = "\\int" }, fmta("\\int <> \\, d<> <>", { i(1), i(2, "x"), i(3) }), { condition = in_mathzone }),
	s(
		{ trig = "dint", snippetType = "autosnippet" },
		fmta("\\int_{<>}^{<>} <> \\, d<> <>", { i(1, "0"), i(2, "1"), i(3), i(4, "x"), i(5) }),
		{ condition = in_mathzone }
	),
	s({ trig = "oint", snippetType = "autosnippet" }, { t("\\oint") }, { condition = in_mathzone }),
	s({ trig = "oiint", snippetType = "autosnippet" }, { t("\\oiint") }, { condition = in_mathzone }),
	s({ trig = "oiiint", snippetType = "autosnippet" }, { t("\\oiiint") }, { condition = in_mathzone }),
	s({ trig = "iint", snippetType = "autosnippet" }, { t("\\iint") }, { condition = in_mathzone }),
	s({ trig = "iiint", snippetType = "autosnippet" }, { t("\\iiint") }, { condition = in_mathzone }),
	s(
		{ trig = "oinf", snippetType = "autosnippet" },
		fmta("\\int_{0}^{\\infty} <> \\, d<> <>", { i(1), i(2, "x"), i(3) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "infi", snippetType = "autosnippet" },
		fmta("\\int_{-\\infty}^{\\infty} <> \\, d<> <>", { i(1), i(2, "x"), i(3) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "kron", snippetType = "autosnippet" },
		fmta("\\delta_{<>}^{<>} <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),

	-- Funções Trigonométricas
	s(
		{
			trig = "([^\\\\])(arcsin|sin|arccos|cos|arctan|tan|csc|sec|cot)",
			regTrig = true,
			snippetType = "autosnippet",
		},
		f(function(_, p)
			return p.snippet.captures[1] .. "\\" .. p.snippet.captures[2]
		end),
		{ condition = in_mathzone }
	),

	-- =================================================================
	-- PHYSICS & QUANTUM MECHANICS
	-- =================================================================
	s(
		{ trig = "coul", snippetType = "autosnippet" },
		{ t("\\frac{1}{4 \\pi \\epsilon_0}") },
		{ condition = in_mathzone }
	),
	s({ trig = "kbt", snippetType = "autosnippet" }, { t("k_{B}T") }, { condition = in_mathzone }),
	s({ trig = "msun", snippetType = "autosnippet" }, { t("M_{\\odot}") }, { condition = in_mathzone }),
	s({ trig = "ri", snippetType = "autosnippet" }, { t("\\vec{r}_{i}") }, { condition = in_mathzone }),
	s({ trig = "dri", snippetType = "autosnippet" }, { t("\\dot{\\vec{r}}_{i}") }, { condition = in_mathzone }),
	s({ trig = "vi", snippetType = "autosnippet" }, { t("\\vec{v}_{i}") }, { condition = in_mathzone }),
	s({ trig = "qk", snippetType = "autosnippet" }, { t("q_{k}") }, { condition = in_mathzone }),
	s({ trig = "Ql", snippetType = "autosnippet" }, { t("Q_{l}") }, { condition = in_mathzone }),
	s({ trig = "dqk", snippetType = "autosnippet" }, { t("\\dot{q}_{k}") }, { condition = in_mathzone }),
	s({ trig = "dQl", snippetType = "autosnippet" }, { t("\\dot{Q}_{l}") }, { condition = in_mathzone }),
	s(
		{ trig = "lagrange", snippetType = "autosnippet" },
		fmta(
			"\\frac{d}{d<>} \\left( \\frac{ \\partial <> }{ \\partial <> } \\right)- \\frac{ \\partial <> }{ \\partial <> } = 0",
			{ i(1), i(2), i(3), rep(2), i(4) }
		),
		{ condition = in_mathzone }
	),

	s({ trig = "dag", snippetType = "autosnippet" }, { t("^{\\dagger}") }, { condition = in_mathzone }),
	s({ trig = "o+", snippetType = "autosnippet" }, { t("\\oplus ") }, { condition = in_mathzone }),
	s({ trig = "ox", snippetType = "autosnippet" }, { t("\\otimes ") }, { condition = in_mathzone }),
	s({ trig = "bra", snippetType = "autosnippet" }, fmta("\\bra{<>} <>", { i(1), i(2) }), { condition = in_mathzone }),
	s({ trig = "ket", snippetType = "autosnippet" }, fmta("\\ket{<>} <>", { i(1), i(2) }), { condition = in_mathzone }),
	s(
		{ trig = "brk", snippetType = "autosnippet" },
		fmta("\\braket{ <> | <> } <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "outer", snippetType = "autosnippet" },
		fmta("\\ket{<>} \\bra{<>} <>", { i(1, "\\psi"), rep(1), i(2) }),
		{ condition = in_mathzone }
	),

	-- Química
	s({ trig = "pu", snippetType = "autosnippet" }, fmta("\\pu{ <> }", { i(1) }), { condition = in_mathzone }),
	s({ trig = "cee", snippetType = "autosnippet" }, fmta("\\ce{ <> }", { i(1) }), { condition = in_mathzone }),
	s({ trig = "he4", snippetType = "autosnippet" }, { t("{}^{4}_{2}He ") }, { condition = in_mathzone }),
	s({ trig = "he3", snippetType = "autosnippet" }, { t("{}^{3}_{2}He ") }, { condition = in_mathzone }),
	s(
		{ trig = "iso", snippetType = "autosnippet" },
		fmta("{}^{<>}_{<>}<>", { i(1, "4"), i(2, "2"), i(3, "He") }),
		{ condition = in_mathzone }
	),

	-- =================================================================
	-- MATRIX & ENVIRONMENTS
	-- =================================================================
	s(
		{ trig = "pmat", snippetType = "autosnippet" },
		fmta("\\begin{pmatrix}\n\t<>\n\\end{pmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "bmat", snippetType = "autosnippet" },
		fmta("\\begin{bmatrix}\n\t<>\n\\end{bmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "Bmat", snippetType = "autosnippet" },
		fmta("\\begin{Bmatrix}\n\t<>\n\\end{Bmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "vmat", snippetType = "autosnippet" },
		fmta("\\begin{vmatrix}\n\t<>\n\\end{vmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "Vmat", snippetType = "autosnippet" },
		fmta("\\begin{Vmatrix}\n\t<>\n\\end{Vmatrix}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "matrix", snippetType = "autosnippet" },
		fmta("\\begin{matrix}\n\t<>\n\\end{matrix}", { i(1) }),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "cases", snippetType = "autosnippet" },
		fmta("\\begin{cases}\n\t<>\n\\end{cases}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "align", snippetType = "autosnippet" },
		fmta("\\begin{align}\n\t<>\n\\end{align}", { i(1) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "array", snippetType = "autosnippet" },
		fmta("\\begin{array}\n\t<>\n\\end{array}", { i(1) }),
		{ condition = in_mathzone }
	),

	-- =================================================================
	-- BRACKETS & DELIMITERS
	-- =================================================================
	s(
		{ trig = "avg", snippetType = "autosnippet" },
		fmta("\\langle <> \\rangle <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "norm", snippetType = "autosnippet", priority = 1 },
		fmta("\\norm{<>} <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "abs", snippetType = "autosnippet", priority = 1 },
		fmta("\\abs{<>} <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "ceil", snippetType = "autosnippet" },
		fmta("\\lceil <> \\rceil <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "floor", snippetType = "autosnippet" },
		fmta("\\lfloor <> \\rfloor <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s({ trig = "mod", snippetType = "autosnippet" }, fmta("|<>|<>", { i(1), i(2) }), { condition = in_mathzone }),
	s(
		{ trig = "lr(", snippetType = "autosnippet" },
		fmta("\\left( <> \\right) <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "lr{", snippetType = "autosnippet" },
		fmta("\\left\\{ <> \\right\\} <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "lr[", snippetType = "autosnippet" },
		fmta("\\left[ <> \\right] <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "lr|", snippetType = "autosnippet" },
		fmta("\\left| <> \\right| <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "lra", snippetType = "autosnippet" },
		fmta("\\left<< <> \\right>> <>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),

	-- =================================================================
	-- GREEK LETTERS
	-- =================================================================
	s({ trig = "@a", snippetType = "autosnippet" }, { t("\\alpha") }, { condition = in_mathzone }),
	s({ trig = "@b", snippetType = "autosnippet" }, { t("\\beta") }, { condition = in_mathzone }),
	s({ trig = "@g", snippetType = "autosnippet" }, { t("\\gamma") }, { condition = in_mathzone }),
	s({ trig = "@G", snippetType = "autosnippet" }, { t("\\Gamma") }, { condition = in_mathzone }),
	s({ trig = "@d", snippetType = "autosnippet" }, { t("\\delta") }, { condition = in_mathzone }),
	s({ trig = "@D", snippetType = "autosnippet" }, { t("\\Delta") }, { condition = in_mathzone }),
	s({ trig = "@e", snippetType = "autosnippet" }, { t("\\epsilon") }, { condition = in_mathzone }),
	s({ trig = ":e", snippetType = "autosnippet" }, { t("\\varepsilon") }, { condition = in_mathzone }),
	s({ trig = "@z", snippetType = "autosnippet" }, { t("\\zeta") }, { condition = in_mathzone }),
	s({ trig = "@t", snippetType = "autosnippet" }, { t("\\theta") }, { condition = in_mathzone }),
	s({ trig = "@T", snippetType = "autosnippet" }, { t("\\Theta") }, { condition = in_mathzone }),
	s({ trig = ":t", snippetType = "autosnippet" }, { t("\\vartheta") }, { condition = in_mathzone }),
	s({ trig = "@i", snippetType = "autosnippet" }, { t("\\iota") }, { condition = in_mathzone }),
	s({ trig = "@k", snippetType = "autosnippet" }, { t("\\kappa") }, { condition = in_mathzone }),
	s({ trig = "@l", snippetType = "autosnippet" }, { t("\\lambda") }, { condition = in_mathzone }),
	s({ trig = "@L", snippetType = "autosnippet" }, { t("\\Lambda") }, { condition = in_mathzone }),
	s({ trig = "@s", snippetType = "autosnippet" }, { t("\\sigma") }, { condition = in_mathzone }),
	s({ trig = "@S", snippetType = "autosnippet" }, { t("\\Sigma") }, { condition = in_mathzone }),
	s({ trig = "@u", snippetType = "autosnippet" }, { t("\\upsilon") }, { condition = in_mathzone }),
	s({ trig = "@U", snippetType = "autosnippet" }, { t("\\Upsilon") }, { condition = in_mathzone }),
	s({ trig = "@o", snippetType = "autosnippet" }, { t("\\omega") }, { condition = in_mathzone }),
	s({ trig = "@O", snippetType = "autosnippet" }, { t("\\Omega") }, { condition = in_mathzone }),
	s({ trig = "ome", snippetType = "autosnippet" }, { t("\\omega") }, { condition = in_mathzone }),
	s({ trig = "Ome", snippetType = "autosnippet" }, { t("\\Omega") }, { condition = in_mathzone }),

	-- =================================================================
	-- ADVANCED DYNAMIC SNIPPETS
	-- =================================================================
	s(
		{ trig = "tayl", snippetType = "autosnippet" },
		fmta(
			"<>(<> + <>) = <>(<>) + <>'(<>)<> + <>''(\\lambda) \\frac{<>^{2}}{2!} + \\dots<>",
			{ i(1, "f"), i(2, "x"), i(3, "h"), rep(1), rep(2), rep(1), rep(2), rep(3), rep(1), rep(3), i(4) }
		),
		{ condition = in_mathzone }
	),

	-- Matriz Identidade N x N (Função Dinâmica)
	s(
		{ trig = "iden(%d)", regTrig = true, snippetType = "autosnippet" },
		d(1, function(_, parent)
			local n = tonumber(parent.snippet.captures[1])
			local nodes = {}
			for r = 1, n do
				for c = 1, n do
					if r == c then
						table.insert(nodes, t("1"))
					else
						table.insert(nodes, t("0"))
					end
					if c < n then
						table.insert(nodes, t(" & "))
					end
				end
				if r < n then
					table.insert(nodes, t(" \\\\\n\t"))
				end
			end
			return sn(nil, fmta("\\begin{pmatrix}\n\t<>\n\\end{pmatrix}", { nodes }))
		end),
		{ condition = in_mathzone }
	),

	-- Adicione ao final da tabela de snippets do tex.lua:
	s(
		{ trig = "incfig", snippetType = "autosnippet" },
		fmta(
			[[
\begin{figure}[htbp]
    \centering
    \incfig{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}
]],
			{ i(1), i(2), rep(1) }
		),
		{ condition = in_text }
	),
}
