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
require('fzf-lua').setup({
  'default',
  files = { formatter = 'path.filename_first' },
  grep = { formatter = 'path.filename_first' },
})
require('fzf-lua').register_ui_select()

map('n', '<C-p>', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
map('n', '<leader>sf', '<cmd>FzfLua files<CR>', { desc = '[S]earch [F]iles' })
map('n', '<leader>sh', '<cmd>FzfLua helptags<CR>', { desc = '[S]earch [H]elp' })
map('n', '<leader>sw', '<cmd>FzfLua grep_cword<CR>', { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', '<cmd>FzfLua live_grep<CR>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<CR>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', '<cmd>FzfLua resume<CR>', { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', '<cmd>FzfLua oldfiles<CR>', { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader>sb', '<cmd>FzfLua buffers<CR>', { desc = '[S]earch [B]uffers' })
map('n', '<leader>sk', '<cmd>FzfLua keymaps<CR>', { desc = '[S]earch [K]eymaps' })
map('n', '<leader>ss', '<cmd>FzfLua lsp_document_symbols<CR>', { desc = '[S]earch [S]ymbols' })
map('n', '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<CR>', { desc = '[S]earch Workspace [S]ymbols' })

-- Quick access aliases
map('n', '<leader>b', '<cmd>FzfLua buffers<CR>', { desc = 'Buffers' })
map('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
map('n', '<leader>/', '<cmd>FzfLua blines<CR>', { desc = 'Buffer lines' })

-- LSP
map('n', 'gd', '<cmd>FzfLua lsp_definitions<CR>', { desc = 'Go to definition' })
map('n', 'gr', '<cmd>FzfLua lsp_references<CR>', { desc = 'Go to references' })
map('n', 'gi', '<cmd>FzfLua lsp_implementations<CR>', { desc = 'Go to implementations' })
map('n', '<leader>ca', '<cmd>FzfLua lsp_code_actions<CR>', { desc = 'Code actions' })

-- Visual mode grep
map('v', '<leader>sw', '<cmd>FzfLua grep_visual<CR>', { desc = '[S]earch [W]ord in visual' })

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
