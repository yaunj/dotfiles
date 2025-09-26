require('core.options')
require('core.keymaps')

-- Lazy plugin manager {{{
-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

vim.g.have_nerd_font = true

-- Maybe attempt to define a cloudformation filetype to more easily set linter and formatter
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
--     pattern = { '*.yml', '*.yaml' },
--     callback = function()
--         local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
--         if string.find(first_line, 'AWSTemplateFormatVersion') then vim.bo.filetype = 'yaml.cloudformation' end
--     end,
-- })

require('lazy').setup({
    require('plugins.colorscheme'),
    require('plugins.mini'),
    require('plugins.gitsigns'),
    require('plugins.autopairs'),
    require('plugins.comment'),
    require('plugins.autocompletion'),
    require('plugins.lsp'),
    require('plugins.formatting'),
    require('plugins.linting'),
    require('plugins.which-key'),
    -- require('plugins.none-ls'),
    require('plugins.telescope'),
    require('plugins.treesitter'),
    require('plugins.tpope'),
    require('plugins.toggleterm'),
})

-- }}}

-- vim: set foldmethod=marker
