local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	-- Codeblock: digite ``` e expande
	s({ trig = "coblock", snippetType = "autosnippet" }, fmta("```<>\n<>\n```", { i(1), i(2) })),

	-- Code inline: digite `` e expande
	s({ trig = "code", snippetType = "autosnippet" }, fmta("`<>`<>", { i(1), i(2) })),
}
