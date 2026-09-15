local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local in_mathzone = tex.in_mathzone

return {
	-- =================================================================
	-- BASIC OPERATIONS & EXPONENTS
	-- =================================================================
	-- sr: Eleva a expressão anterior ao quadrado, sem exigir espaço.
	s({ trig = "sr", wordTrig = false, snippetType = "autosnippet" }, { t("^{2}") }, { condition = in_mathzone }),
	-- cb: Eleva a expressão anterior ao cubo, sem exigir espaço.
	s({ trig = "cb", wordTrig = false, snippetType = "autosnippet" }, { t("^{3}") }, { condition = in_mathzone }),
	-- rd: Expoente editável após a expressão anterior.
	s(
		{ trig = "rd", wordTrig = false, snippetType = "autosnippet" },
		fmta("^{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- _: Subscrito editável após a expressão anterior.
	s(
		{ trig = "_", wordTrig = false, snippetType = "autosnippet" },
		fmta("_{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- sts: Subscrito textual agrupado corretamente (amsmath).
	s(
		{ trig = "sts", wordTrig = false, snippetType = "autosnippet" },
		fmta("_{\\text{<>}}", { i(1) }),
		{ condition = in_mathzone }
	),
	-- sq: Raiz quadrada com radicando editável.
	s(
		{ trig = "sq", snippetType = "autosnippet" },
		fmta("\\sqrt{ <> }<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- ff: Fração com numerador e denominador editáveis.
	s(
		{ trig = "ff", snippetType = "autosnippet" },
		fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
	-- Numerador/: transforma 12/, 2x/ ou \alpha_1^{2}/ em fração automaticamente.
	-- Aceita expoentes e índices numéricos; Tab sai do denominador para o fim.
	-- O motor Vim aceita alternâncias e grupos repetidos sem depender de jsregexp.
	s(
		{
			trig = [[\v((\d+)|(\d*)(\\)?([A-Za-z]+)((\^|_)(\{\d+\}|\d))*)/]],
			trigEngine = "vim",
			wordTrig = true,
			snippetType = "autosnippet",
			dscr = "Fração com o numerador anterior à barra",
		},
		fmta("\\frac{<>}{<>}<>", {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
			i(0),
		}),
		{ condition = in_mathzone }
	),
	-- ee: Exponencial de base e.
	s({ trig = "ee", snippetType = "autosnippet" }, fmta("e^{ <> }<>", { i(1), i(2) }), { condition = in_mathzone }),
	-- invs: Expoente -1 para inversa.
	s({ trig = "invs", wordTrig = false, snippetType = "autosnippet" }, { t("^{-1}") }, { condition = in_mathzone }),
	-- conj: Estrela em sobrescrito para conjugação.
	s({ trig = "conj", wordTrig = false, snippetType = "autosnippet" }, { t("^{*}") }, { condition = in_mathzone }),
	-- Re: Insere \mathrm{Re}.
	s({ trig = "Re", snippetType = "autosnippet" }, { t("\\mathrm{Re}") }, { condition = in_mathzone }),
	-- Im: Insere \mathrm{Im}.
	s({ trig = "Im", snippetType = "autosnippet" }, { t("\\mathrm{Im}") }, { condition = in_mathzone }),
	-- bf: Conteúdo matemático em negrito.
	s({ trig = "bf", snippetType = "autosnippet" }, fmta("\\mathbf{<>}", { i(1) }), { condition = in_mathzone }),
	-- rm: Conteúdo matemático em fonte romana.
	s(
		{ trig = "rm", snippetType = "autosnippet" },
		fmta("\\mathrm{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),

	-- Subscritos Automáticos (Regex)
	-- ([A-Za-z])(%d): Converte letra seguida de dígito em subscrito: x1 → x_{1}.
	s(
		{ trig = "([A-Za-z])(%d)", regTrig = true, snippetType = "autosnippet", priority = -1 },
		f(function(_, p)
			return p.snippet.captures[1] .. "_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- ([A-Za-z])_{(%d+)}(%d): Acrescenta dígitos ao subscrito: x_{1}2 → x_{12}.
	s(
		{ trig = "([A-Za-z])_{(%d+)}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return p.snippet.captures[1] .. "_{" .. p.snippet.captures[2] .. p.snippet.captures[3] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- \hat{([A-Za-z])}(%d): Subscrito numérico após letra com chapéu.
	s(
		{ trig = "\\hat{([A-Za-z])}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\hat{" .. p.snippet.captures[1] .. "}_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- \vec{([A-Za-z])}(%d): Subscrito numérico após vetor.
	s(
		{ trig = "\\vec{([A-Za-z])}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\vec{" .. p.snippet.captures[1] .. "}_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- \mathbf{([A-Za-z])}(%d): Subscrito numérico após letra em negrito.
	s(
		{ trig = "\\mathbf{([A-Za-z])}(%d)", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\mathbf{" .. p.snippet.captures[1] .. "}_{" .. p.snippet.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- Atalhos de Variáveis Frequentes
	-- xnn: Insere x_{n}.
	s({ trig = "xnn", snippetType = "autosnippet" }, { t("x_{n}") }, { condition = in_mathzone }),
	-- xii: Insere x_{i}.
	s({ trig = "xii", snippetType = "autosnippet", priority = 1 }, { t("x_{i}") }, { condition = in_mathzone }),
	-- xjj: Insere x_{j}.
	s({ trig = "xjj", snippetType = "autosnippet" }, { t("x_{j}") }, { condition = in_mathzone }),
	-- xp1: Insere x_{n+1}.
	s({ trig = "xp1", snippetType = "autosnippet" }, { t("x_{n+1}") }, { condition = in_mathzone }),
	-- ynn: Insere y_{n}.
	s({ trig = "ynn", snippetType = "autosnippet" }, { t("y_{n}") }, { condition = in_mathzone }),
	-- yii: Insere y_{i}.
	s({ trig = "yii", snippetType = "autosnippet" }, { t("y_{i}") }, { condition = in_mathzone }),
	-- yjj: Insere y_{j}.
	s({ trig = "yjj", snippetType = "autosnippet" }, { t("y_{j}") }, { condition = in_mathzone }),

	-- =================================================================
	-- LINEAR ALGEBRA & ACCENTS
	-- =================================================================
	-- trace: Insere \mathrm{Tr}.
	s({ trig = "trace", snippetType = "autosnippet" }, { t("\\mathrm{Tr}") }, { condition = in_mathzone }),
	-- basis: Base de vetores e_i, com índices de 0 a 3.
	s(
		{ trig = "basis", snippetType = "autosnippet" },
		{ t("\\{ e_{i} \\}_{i = 0, 1, 2, 3}") },
		{ condition = in_mathzone }
	),
	-- tns: Tensor com conteúdo e índices; requer pacote tensor ou macro equivalente.
	s(
		{ trig = "tns", snippetType = "autosnippet" },
		fmta("\\tensor{<>}{<>}", { i(1), i(2) }),
		{ condition = in_mathzone }
	),

	-- Diacríticos
	-- ([a-zA-Z])hat: Aplica chapéu à letra anterior; exemplo: xhat.
	s(
		{ trig = "([a-zA-Z])hat", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\hat{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])bar: Aplica barra superior à letra anterior; exemplo: xbar.
	s(
		{ trig = "([a-zA-Z])bar", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\bar{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])dot: Aplica ponto superior à letra anterior; exemplo: xdot.
	s(
		{ trig = "([a-zA-Z])dot", regTrig = true, snippetType = "autosnippet", priority = -1 },
		f(function(_, p)
			return "\\dot{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])ddot: Aplica dois pontos superiores à letra anterior; exemplo: xddot.
	s(
		{ trig = "([a-zA-Z])ddot", regTrig = true, snippetType = "autosnippet", priority = 1 },
		f(function(_, p)
			return "\\ddot{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])tilde: Aplica til à letra anterior; exemplo: xtilde.
	s(
		{ trig = "([a-zA-Z])tilde", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\tilde{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])und: Aplica sublinhado à letra anterior; exemplo: xund.
	s(
		{ trig = "([a-zA-Z])und", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\underline{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])vec: Aplica seta de vetor à letra anterior; exemplo: xvec.
	s(
		{ trig = "([a-zA-Z])vec", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\vec{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z]),%.: Coloca a letra anterior em negrito ao digitar x,.
	s(
		{ trig = "([a-zA-Z]),%.", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\mathbf{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),
	-- ([a-zA-Z])%.,: Coloca a letra anterior em negrito ao digitar x.,
	s(
		{ trig = "([a-zA-Z])%.,", regTrig = true, snippetType = "autosnippet" },
		f(function(_, p)
			return "\\mathbf{" .. p.snippet.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- hat: Insere chapéu sobre conteúdo editável.
	s({ trig = "hat", snippetType = "autosnippet" }, fmta("\\hat{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	-- bar: Insere barra superior sobre conteúdo editável.
	s({ trig = "bar", snippetType = "autosnippet" }, fmta("\\bar{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),
	-- dot: Insere ponto superior sobre conteúdo editável.
	s(
		{ trig = "dot", snippetType = "autosnippet", priority = -1 },
		fmta("\\dot{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- ddot: Insere dois pontos superiores sobre conteúdo editável.
	s(
		{ trig = "ddot", priority = 1100, snippetType = "autosnippet" },
		fmta("\\ddot{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- cdot: Insere \cdot.
	s({ trig = "cdot", priority = 1100, snippetType = "autosnippet" }, { t("\\cdot") }, { condition = in_mathzone }),
	-- tilde: Insere til sobre conteúdo editável.
	s(
		{ trig = "tilde", snippetType = "autosnippet" },
		fmta("\\tilde{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- und: Insere sublinhado sobre conteúdo editável.
	s(
		{ trig = "und", snippetType = "autosnippet" },
		fmta("\\underline{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- vec: Insere seta de vetor sobre conteúdo editável.
	s({ trig = "vec", snippetType = "autosnippet" }, fmta("\\vec{<>}<>", { i(1), i(2) }), { condition = in_mathzone }),

	-- Funções trigonométricas: cada gatilho usa correspondência literal.
	-- arcsin: Insere \arcsin.
	s({ trig = "arcsin", snippetType = "autosnippet" }, { t("\\arcsin") }, { condition = in_mathzone }),
	-- sin: Insere \sin.
	s({ trig = "sin", snippetType = "autosnippet" }, { t("\\sin") }, { condition = in_mathzone }),
	-- arccos: Insere \arccos.
	s({ trig = "arccos", snippetType = "autosnippet" }, { t("\\arccos") }, { condition = in_mathzone }),
	-- cos: Insere \cos.
	s({ trig = "cos", snippetType = "autosnippet" }, { t("\\cos") }, { condition = in_mathzone }),
	-- arctan: Insere \arctan.
	s({ trig = "arctan", snippetType = "autosnippet" }, { t("\\arctan") }, { condition = in_mathzone }),
	-- tan: Insere \tan.
	s({ trig = "tan", snippetType = "autosnippet" }, { t("\\tan") }, { condition = in_mathzone }),
	-- csc: Insere \csc.
	s({ trig = "csc", snippetType = "autosnippet" }, { t("\\csc") }, { condition = in_mathzone }),
	-- sec: Insere \sec.
	s({ trig = "sec", snippetType = "autosnippet" }, { t("\\sec") }, { condition = in_mathzone }),
	-- cot: Insere \cot.
	s({ trig = "cot", snippetType = "autosnippet" }, { t("\\cot") }, { condition = in_mathzone }),

	-- func: Função com nome, domínio e contradomínio editáveis.
	s(
		{ trig = "func", snippetType = "autosnippet" },
		fmta("<>: <> \\to <>", { i(1), i(2), i(3) }),
		{ condition = in_mathzone }
	),
}
