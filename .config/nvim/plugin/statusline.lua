local mode_map = {
  n       = 'NRM',  -- 'NORMAL',
  i       = 'INS',  -- 'INSERT',
  v       = 'VIS',  -- 'VISUAL',
  V       = 'V-L',  -- 'V-LINE',
  ['\22'] = 'V-B',  -- 'V-BLOCK',
  c       = 'CMD',  -- 'COMMAND',
  R       = 'RPL',  -- 'REPLACE',
  t       = 'TRM',  -- 'TERMINAL',
  s       = 'SEL',  -- 'SELECT',
  S       = 'S-L',  -- 'S-LINE',
  ['\19'] = 'S-B',  -- 'S-BLOCK',
}

local mode_hl = {
  n       = 'StlModeNormal',
  i       = 'StlModeInsert',
  v       = 'StlModeVisual',
  V       = 'StlModeVisual',
  ['\22'] = 'StlModeVisual',
  c       = 'StlModeCommand',
  R       = 'StlModeReplace',
  t       = 'StlModeTerminal',
  s       = 'StlModeVisual',
  S       = 'StlModeVisual',
  ['\19'] = 'StlModeVisual',
}

function Statusline_mode()
  local m = vim.fn.mode()
  return '%#' .. (mode_hl[m] or 'StlModeNormal') .. '# ' .. (mode_map[m] or m) .. ' %*'
end

function Statusline_git_branch()
  local ok, gitsigns = pcall(vim.api.nvim_buf_get_var, 0, 'gitsigns_head')
  if ok and gitsigns then return '%#StlGit#(' .. gitsigns .. ')%*' end
  return ''
end

function Statusline_diagnostics()
  local parts = {}
  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  if e > 0 then table.insert(parts, '%#DiagnosticError# E:' .. e .. ' ') end
  if w > 0 then table.insert(parts, '%#DiagnosticWarn# W:' .. w .. ' ') end
  if #parts == 0 then return '' end
  return table.concat(parts) .. '%*'
end

-- Highlight groups — derived from semantic groups so they follow any colorscheme
local function set_stl_highlights()
  local function reverse_bold(source)
    local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
    return { fg = hl.bg, bg = hl.fg, bold = true }
  end

  vim.api.nvim_set_hl(0, 'StlModeNormal',  reverse_bold('Function'))
  vim.api.nvim_set_hl(0, 'StlModeInsert',  reverse_bold('String'))
  vim.api.nvim_set_hl(0, 'StlModeVisual',  reverse_bold('Keyword'))
  vim.api.nvim_set_hl(0, 'StlModeCommand', reverse_bold('Constant'))
  vim.api.nvim_set_hl(0, 'StlModeReplace', reverse_bold('DiagnosticError'))
  vim.api.nvim_set_hl(0, 'StlModeTerminal',reverse_bold('Special'))
  vim.api.nvim_set_hl(0, 'StlGit',         { link = 'DiffAdd' })
  vim.api.nvim_set_hl(0, 'StlFiletype',    { link = 'StatusLineNC' })
  vim.api.nvim_set_hl(0, 'StlPosition',    { link = 'CurSearch' })
end
set_stl_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_stl_highlights })

vim.opt.statusline = table.concat({
  '%{%v:lua.Statusline_mode()%}',           -- mode (colored per-mode)
  ' %f',                                    -- filename
  ' %#StlFiletype#%Y%M%R%W%*',              -- filetype + flags
  ' %<%{%v:lua.Statusline_git_branch()%}',  -- git branch
  '%=',                                     -- right align
  '%{%v:lua.Statusline_diagnostics()%}',    -- diagnostic counts (colored)
  ' %#StlFiletype# %{&fenc},%{&ff} %*',     -- encoding + format
  '%#StlPosition# %l:%v %P ',               -- position + percent
})
