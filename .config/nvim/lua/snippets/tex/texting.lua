local ls = require("luasnip")
local tex = require("config.tex_snippets")
local s = tex.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local in_mathzone = tex.in_mathzone

return {

	-- =================================================================
	-- TEXT & SPACING IN MATH
	-- =================================================================
	-- text: Texto dentro de uma expressão matemática (amsmath).
	s(
		{ trig = "text", snippetType = "autosnippet" },
		fmta("\\text{<>}<>", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	-- quad: Insere \quad.
	s({ trig = "quad", snippetType = "autosnippet" }, { t("\\quad ") }, { condition = in_mathzone }),
	-- qquad: Insere \quad \quad.
	s({ trig = "qquad", snippetType = "autosnippet" }, { t("\\quad \\quad ") }, { condition = in_mathzone }),

	-- =================================================================
	-- GREEK LETTERS
	-- =================================================================
	-- @a: Insere \alpha.
	s({ trig = "@a", wordTrig = false, snippetType = "autosnippet" }, { t("\\alpha") }, { condition = in_mathzone }),
	-- @b: Insere \beta.
	s({ trig = "@b", wordTrig = false, snippetType = "autosnippet" }, { t("\\beta") }, { condition = in_mathzone }),
	-- @g: Insere \gamma.
	s({ trig = "@g", wordTrig = false, snippetType = "autosnippet" }, { t("\\gamma") }, { condition = in_mathzone }),
	-- @G: Insere \Gamma.
	s({ trig = "@G", wordTrig = false, snippetType = "autosnippet" }, { t("\\Gamma") }, { condition = in_mathzone }),
	-- @d: Insere \delta.
	s({ trig = "@d", wordTrig = false, snippetType = "autosnippet" }, { t("\\delta") }, { condition = in_mathzone }),
	-- @D: Insere \Delta.
	s({ trig = "@D", wordTrig = false, snippetType = "autosnippet" }, { t("\\Delta") }, { condition = in_mathzone }),
	-- @e: Insere \epsilon.
	s({ trig = "@e", wordTrig = false, snippetType = "autosnippet" }, { t("\\epsilon") }, { condition = in_mathzone }),
	-- :e: Insere \varepsilon.
	s(
		{ trig = ":e", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\varepsilon") },
		{ condition = in_mathzone }
	),
	-- @z: Insere \zeta.
	s({ trig = "@z", wordTrig = false, snippetType = "autosnippet" }, { t("\\zeta") }, { condition = in_mathzone }),
	-- @t: Insere \theta.
	s({ trig = "@t", wordTrig = false, snippetType = "autosnippet" }, { t("\\theta") }, { condition = in_mathzone }),
	-- @T: Insere \Theta.
	s({ trig = "@T", wordTrig = false, snippetType = "autosnippet" }, { t("\\Theta") }, { condition = in_mathzone }),
	-- :t: Insere \vartheta.
	s({ trig = ":t", wordTrig = false, snippetType = "autosnippet" }, { t("\\vartheta") }, { condition = in_mathzone }),
	-- @i: Insere \iota.
	s({ trig = "@i", wordTrig = false, snippetType = "autosnippet" }, { t("\\iota") }, { condition = in_mathzone }),
	-- @k: Insere \kappa.
	s({ trig = "@k", wordTrig = false, snippetType = "autosnippet" }, { t("\\kappa") }, { condition = in_mathzone }),
	-- @l: Insere \lambda.
	s({ trig = "@l", wordTrig = false, snippetType = "autosnippet" }, { t("\\lambda") }, { condition = in_mathzone }),
	-- @L: Insere \Lambda.
	s({ trig = "@L", wordTrig = false, snippetType = "autosnippet" }, { t("\\Lambda") }, { condition = in_mathzone }),
	-- @s: Insere \sigma.
	s({ trig = "@s", wordTrig = false, snippetType = "autosnippet" }, { t("\\sigma") }, { condition = in_mathzone }),
	-- @S: Insere \Sigma.
	s({ trig = "@S", wordTrig = false, snippetType = "autosnippet" }, { t("\\Sigma") }, { condition = in_mathzone }),
	-- @u: Insere \upsilon.
	s({ trig = "@u", wordTrig = false, snippetType = "autosnippet" }, { t("\\upsilon") }, { condition = in_mathzone }),
	-- @U: Insere \Upsilon.
	s({ trig = "@U", wordTrig = false, snippetType = "autosnippet" }, { t("\\Upsilon") }, { condition = in_mathzone }),
	-- @o: Insere \omega.
	s({ trig = "@o", wordTrig = false, snippetType = "autosnippet" }, { t("\\omega") }, { condition = in_mathzone }),
	-- @O: Insere \Omega.
	s({ trig = "@O", wordTrig = false, snippetType = "autosnippet" }, { t("\\Omega") }, { condition = in_mathzone }),
	-- ome: Insere \omega.
	s({ trig = "ome", snippetType = "autosnippet" }, { t("\\omega") }, { condition = in_mathzone }),
	-- Ome: Insere \Omega.
	s({ trig = "Ome", snippetType = "autosnippet" }, { t("\\Omega") }, { condition = in_mathzone }),
}
