 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#291417',
    base01 = '#452126',
    base02 = '#3e1e23',
    base03 = '#716264',
    base04 = '#b6afb0',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#f8516a',
    base09 = '#f8df51',
    base0A = '#f88b51',
    base0B = '#f8536c',
    base0C = '#fae884',
    base0D = '#fa8496',
    base0E = '#faad84',
    base0F = '#fcceb5',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#291417' })
  hi('TelescopeBorder',         { fg = '#716264',             bg = '#291417' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#291417' })
  hi('TelescopePromptBorder',   { fg = '#716264',             bg = '#291417' })
  hi('TelescopePromptPrefix',   { fg = '#f8536c',             bg = '#291417' })
  hi('TelescopePromptCounter',  { fg = '#b6afb0',  bg = '#291417' })
  hi('TelescopePromptTitle',    { fg = '#291417',             bg = '#f8536c' })
  hi('TelescopePreviewTitle',   { fg = '#291417',             bg = '#f88b51' })
  hi('TelescopeResultsTitle',   { fg = '#291417',             bg = '#f8df51' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#3e1e23' })
  hi('TelescopeSelectionCaret', { fg = '#f8536c',             bg = '#3e1e23' })
  hi('TelescopeMatching',       { fg = '#f8536c',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
