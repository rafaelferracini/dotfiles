-- Executar em Neovim isolado: nvim --headless -u NONE -i NONE -l ~/.config/nvim/tests/tex_autosize.lua
vim.opt.rtp:prepend(vim.fn.stdpath("config"))
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/vimtex")
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/LuaSnip")
vim.g.vimtex_view_enabled = 0
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
vim.cmd("setfiletype tex")
vim.wo.virtualedit = "onemore"
local autosize = require("config.tex_autosize")
local count = 0
local function check(input, expected, needle)
	local lines = vim.split(input, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	local row, col = 1, nil
	for n, line in ipairs(lines) do
		col = line:find(needle or "frac", 1, true)
		if col then
			row = n
			break
		end
	end
	assert(col, input)
	vim.api.nvim_win_set_cursor(0, { row, col })
	vim.cmd("syntax sync fromstart")
	autosize.update()
	local actual = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	assert(actual == expected, "\n" .. input .. "\nactual: " .. actual .. "\nexpect: " .. expected)
	autosize.update()
	assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") == expected, "idempotence")
	count = count + 1
end
check("$(" .. "\\frac{1}{2})$", "$\\left(\\frac{1}{2}\\right)$")
check("$[\\sum_{i=1}^n x_i]$", "$\\left[\\sum_{i=1}^n x_i\\right]$", "sum")
check("$\\{\\prod_{i=1}^n x_i\\}$", "$\\left\\{\\prod_{i=1}^n x_i\\right\\}$", "prod")
check("$([\\frac{1}{2}])$", "$\\left(\\left[\\frac{1}{2}\\right]\\right)$")
check("$\\langle\\int_0^1 f(x) dx\\rangle$", "$\\left\\langle\\int_0^1 f(x) dx\\right\\rangle$", "int")
check("$\\left(\\frac{1}{2}\\right)$", "$\\left(\\frac{1}{2}\\right)$")
check("$\\bigl(\\frac{1}{2}\\bigr)$", "$\\bigl(\\frac{1}{2}\\bigr)$")
check("$\\left([\\frac{1}{2}]\\right)$", "$\\left(\\left[\\frac{1}{2}\\right]\\right)$")
check("(\\frac{1}{2})", "(\\frac{1}{2})")
check("% $(\\frac{1}{2})$", "% $(\\frac{1}{2})$")
check("$\\text{(\\frac{1}{2})}$", "$\\text{(\\frac{1}{2})}$")
check("$(x+1)$", "$(x+1)$", "x")
check("$(\\fraction{x})$", "$(\\fraction{x})$")
check("$(\\frac{1}{2}$", "$(\\frac{1}{2}$")
check("\\[\n(\\frac{1}{2}\n+ x)\n\\]", "\\[\n\\left(\\frac{1}{2}\n+ x\\right)\n\\]")
check("$({\\frac{1}{2})}$", "$({\\frac{1}{2})}$")
check("\\begin{align}\n(\\frac{1}{2} & x)\n\\end{align}", "\\begin{align}\n(\\frac{1}{2} & x)\n\\end{align}")
check("\\begin{align}\n(\\frac{1}{2} \\\\ x)\n\\end{align}", "\\begin{align}\n(\\frac{1}{2} \\\\ x)\n\\end{align}")
-- Expansion within an existing pair must keep insert nodes and the exit usable.
local ls = require("luasnip")
local snippets = dofile(vim.fn.stdpath("config") .. "/lua/snippets/tex/math.lua")
local ff
for _, s in ipairs(snippets) do
	if s.trigger == "ff" then
		ff = s
	end
end
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "$(ff)$" })
vim.api.nvim_win_set_cursor(0, { 1, 4 })
vim.cmd("syntax sync fromstart")
local params = ff:matches("$(ff")
assert(params)
ls.snip_expand(ff, { expand_params = params, clear_region = { from = { 0, 2 }, to = { 0, 4 } } })
autosize.update()
assert(vim.api.nvim_get_current_line() == "$\\left(\\frac{}{}\\right)$", vim.api.nvim_get_current_line())
local function type_node(text)
	local node = ls.session.current_nodes[vim.api.nvim_get_current_buf()]
	local from, to = node.mark:pos_begin_end_raw()
	vim.api.nvim_buf_set_text(0, from[1], from[2], to[1], to[2], { text })
	vim.api.nvim_win_set_cursor(0, { from[1] + 1, from[2] + #text })
	ls.active_update_dependents()
end
type_node("1")
ls.jump(1)
type_node("2")
ls.jump(1)
assert(vim.api.nvim_get_current_line() == "$\\left(\\frac{1}{2}\\right)$", vim.api.nvim_get_current_line())
assert(ls.session.current_nodes[vim.api.nvim_get_current_buf()].pos == 3)

-- Os eventos de expansão e digitação devem executar o ajuste agendado.
autosize.setup()
local function check_event(snip, input, before, expected)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { input })
	vim.api.nvim_win_set_cursor(0, { 1, #before })
	vim.cmd("syntax sync fromstart")
	local match = snip:matches(before)
	assert(match, before)
	ls.snip_expand(
		snip,
		{ expand_params = match, clear_region = { from = { 0, #before - #match.trigger }, to = { 0, #before } } }
	)
	assert(
		vim.wait(100, function()
			return vim.api.nvim_get_current_line() == expected
		end, 10),
		vim.api.nvim_get_current_line()
	)
	assert(ls.locally_jumpable(1))
	ls.jump(1)
end
local fraction
for _, snip in ipairs(snippets) do
	if snip.dscr[1] == "Fração com o numerador anterior à barra" then
		fraction = snip
	end
end
check_event(fraction, "$(2x/)$", "$(2x/", "$\\left(\\frac{2x}{}\\right)$")
for _, snip in ipairs(dofile(vim.fn.stdpath("config") .. "/lua/snippets/tex/symbol.lua")) do
	if snip.trigger == "sum" or snip.trigger == "prod" then
		local input = "$(" .. snip.trigger .. ")$"
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { input })
		vim.api.nvim_win_set_cursor(0, { 1, #input - 2 })
		vim.cmd("syntax sync fromstart")
		local match = snip:matches(input:sub(1, -3))
		assert(match)
		ls.snip_expand(snip, { expand_params = match, clear_region = { from = { 0, 2 }, to = { 0, #input - 2 } } })
		local expected = "$\\left(\\" .. snip.trigger .. "\\right)$"
		assert(
			vim.wait(100, function()
				return vim.api.nvim_get_current_line() == expected
			end, 10),
			vim.api.nvim_get_current_line()
		)
	end
end
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "$(\\frac{1}{2})$" })
vim.api.nvim_win_set_cursor(0, { 1, 14 })
vim.cmd("syntax sync fromstart")
vim.api.nvim_exec_autocmds("TextChangedI", {})
assert(
	vim.wait(100, function()
		return vim.api.nvim_get_current_line() == "$\\left(\\frac{1}{2}\\right)$"
	end, 10),
	vim.api.nvim_get_current_line()
)
print("OK: " .. count .. " casos e idempotência; LuaSnip preserva numerador, denominador e saída.")
vim.cmd("qa!")
