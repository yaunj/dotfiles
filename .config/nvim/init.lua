-- Leader key (must be set before any keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Core modules
require('core.options')
require('plugins')
require('core.keymaps')
require('core.lsp')
require('core.autocmds')
