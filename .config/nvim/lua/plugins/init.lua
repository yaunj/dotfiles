local gh = function(repo) return 'https://github.com/' .. repo end
local map = vim.keymap.set

-- Plugin list
vim.pack.add({
  gh('catppuccin/nvim'),
  gh('ibhagwan/fzf-lua'),
  gh('nvim-treesitter/nvim-treesitter'),
  gh('nvim-treesitter/nvim-treesitter-textobjects'),
  gh('lewis6991/gitsigns.nvim'),
  gh('stevearc/conform.nvim'),
  gh('folke/which-key.nvim'),
  gh('tpope/vim-sleuth'),
  gh('tpope/vim-fugitive'),
})

-- catppuccin
require('catppuccin').setup({ flavour = 'macchiato' })
vim.cmd.colorscheme('catppuccin-macchiato')

-- fzf-lua
require('fzf-lua').setup({ 'default' })
map('n', '<C-p>', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
map('n', '<leader>sg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>b', '<cmd>FzfLua buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>/', '<cmd>FzfLua blines<CR>', { desc = 'Buffer lines' })
map('n', '<leader>ss', '<cmd>FzfLua lsp_document_symbols<CR>', { desc = 'Document symbols' })
map('n', '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<CR>', { desc = 'Workspace symbols' })
map('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<CR>', { desc = 'Diagnostics' })
map('n', '<leader>sh', '<cmd>FzfLua helptags<CR>', { desc = 'Help tags' })
map('n', '<leader>sk', '<cmd>FzfLua keymaps<CR>', { desc = 'Search keymaps' })
map('n', '<leader>sr', '<cmd>FzfLua resume<CR>', { desc = 'Resume last search' })
map('n', 'gd', '<cmd>FzfLua lsp_definitions<CR>', { desc = 'Go to definition' })

-- treesitter
require('nvim-treesitter').install({
  'bash',
  'dockerfile',
  'go',
  'gomod',
  'hcl',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'terraform',
  'vim',
  'vimdoc',
  'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if pcall(vim.treesitter.language.inspect, lang) then vim.treesitter.start() end
  end,
})

-- treesitter textobjects
require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true, set_jumps = true },
})

local ts_selections = {
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
  ['aa'] = '@parameter.outer',
  ['ia'] = '@parameter.inner',
}
for mapping, query in pairs(ts_selections) do
  map(
    { 'x', 'o' },
    mapping,
    function() require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects') end,
    { desc = query }
  )
end

local ts_movement = { ['f'] = '@function.outer', ['c'] = '@class.outer' }
local tsm = require('nvim-treesitter-textobjects.move')
for mapping, query in pairs(ts_movement) do
  map({ 'n', 'x', 'o' }, ']' .. mapping, function() tsm.goto_next_start(query, 'textobjects') end)
  map({ 'n', 'x', 'o' }, '[' .. mapping, function() tsm.goto_previous_start(query, 'textobjects') end)
end

-- gitsigns
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local opts = function(desc) return { buffer = bufnr, desc = desc } end
    map('n', ']h', gs.next_hunk, opts('Next hunk'))
    map('n', '[h', gs.prev_hunk, opts('Prev hunk'))
    map('n', '<leader>hp', gs.preview_hunk, opts('Preview hunk'))
    map('n', '<leader>hs', gs.stage_hunk, opts('Stage hunk'))
    map('n', '<leader>hr', gs.reset_hunk, opts('Reset hunk'))
    map('n', '<leader>hu', gs.undo_stage_hunk, opts('Undo stage hunk'))
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, opts('Blame line'))
  end,
})

-- which-key
require('which-key').setup({
  delay = 400,
  preset = 'modern',
  icons = { separator = '=' },
})

-- conform
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    ['_'] = { 'trim_whitespace' },
  },
})
map(
  'n',
  '<leader>f',
  function() require('conform').format({ async = true, lsp_fallback = true }) end,
  { desc = 'Format buffer' }
)
