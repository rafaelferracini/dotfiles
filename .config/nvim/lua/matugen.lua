 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#000000',
    base01 = '#281909',
    base02 = '#211407',
    base03 = '#716a61',
    base04 = '#b6b3af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#fd4663',
    base09 = '#66ccbf',
    base0A = '#d5d65c',
    base0B = '#e4a767',
    base0C = '#96e9de',
    base0D = '#ecc093',
    base0E = '#e8e996',
    base0F = '#f3f4be',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#000000' })
  hi('TelescopeBorder',         { fg = '#716a61',             bg = '#000000' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#000000' })
  hi('TelescopePromptBorder',   { fg = '#716a61',             bg = '#000000' })
  hi('TelescopePromptPrefix',   { fg = '#e4a767',             bg = '#000000' })
  hi('TelescopePromptCounter',  { fg = '#b6b3af',  bg = '#000000' })
  hi('TelescopePromptTitle',    { fg = '#000000',             bg = '#e4a767' })
  hi('TelescopePreviewTitle',   { fg = '#000000',             bg = '#d5d65c' })
  hi('TelescopeResultsTitle',   { fg = '#000000',             bg = '#66ccbf' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#211407' })
  hi('TelescopeSelectionCaret', { fg = '#e4a767',             bg = '#211407' })
  hi('TelescopeMatching',       { fg = '#e4a767',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#f3f2f2',          bg = '#000000' })
  hi('MiniPickBorder',         { fg = '#716a61',             bg = '#000000' })
  hi('MiniPickPrompt',   { fg = '#f3f2f2',          bg = '#000000' })
  hi('MiniPickPromptPrefix',   { fg = '#e4a767',             bg = '#000000' })
  hi('MiniPickBorderText',    { fg = '#000000',             bg = '#e4a767' })
  hi('MiniPickMatchCurrent',      { fg = '#f3f2f2',          bg = '#211407' })
  hi('MiniPickPromptCaret', { fg = '#e4a767',             bg = '#211407' })
  hi('MiniPickMatchRanges',       { fg = '#e4a767',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
