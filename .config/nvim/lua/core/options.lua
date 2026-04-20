-- Appearance & UI
require('vim._core.ui2').enable()
vim.opt.showmatch = true
vim.opt.list = true
vim.opt.listchars = { tab = '▸·', extends = '>', precedes = '<', trail = '·', nbsp = '¤' }
vim.opt.cursorline = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.number = true
vim.opt.background = 'dark'

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.isfname:remove('=')

-- Indentation
vim.opt.smartindent = true
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Formatting
vim.opt.formatoptions = 'tcrnq'
vim.opt.textwidth = 80

-- Persistence
vim.opt.undofile = true

-- Shell
if vim.fn.has('win32') == 1 then
  vim.opt.shell = 'powershell'
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

-- Grep
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'

-- :help 'exrc'
vim.opt.exrc = true

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
})
