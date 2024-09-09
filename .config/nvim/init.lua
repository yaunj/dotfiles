require('core.options')
require('core.keymaps')

Config = {}
local version = vim.version()
if version.major <= 0 and version.minor < 8 then
    Config.old_nvim = true
end

-- Lazy plugin manager {{{
-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    require('plugins.colorscheme'),
    require('plugins.lualine'),
    require('plugins.gitsigns'),
    require('plugins.comment'),
    require('plugins.autocompletion'),
    require('plugins.lsp'),
    require('plugins.which-key'),
    require('plugins.none-ls'),
    require('plugins.telescope'),
    require('plugins.treesitter'),
    require('plugins.tpope'),
    require('plugins.toggleterm'),
})

-- }}}

-- vim: set foldmethod=marker
