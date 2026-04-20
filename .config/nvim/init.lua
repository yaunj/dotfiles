-- Leader key (must be set before any keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Helper for GitHub URLs
local gh = function(repo) return 'https://github.com/' .. repo end

-- Plugins
vim.pack.add({
  gh('catppuccin/nvim'),
  gh('ibhagwan/fzf-lua'),
  gh('neovim/nvim-lspconfig'),
  gh('nvim-treesitter/nvim-treesitter'),
  gh('nvim-treesitter/nvim-treesitter-textobjects'),
  gh('lewis6991/gitsigns.nvim'),
  gh('echasnovski/mini.surround'),
  gh('echasnovski/mini.comment'),
  gh('stevearc/conform.nvim'),
  gh('folke/which-key.nvim'),
  gh('tpope/vim-sleuth'),
  gh('tpope/vim-unimpaired'),
  gh('tpope/vim-fugitive'),
  gh('tpope/vim-eunuch'),
})

-- Colorscheme
vim.cmd.colorscheme('catppuccin-macchiato')

-- Options (only what differs from Neovim defaults)
vim.opt.fileformat = 'unix'
vim.opt.fileencoding = 'utf-8'
vim.opt.background = 'dark'

-- Appearance
require('vim._core.ui2').enable()
vim.opt.showmatch = true
vim.opt.list = true
vim.opt.listchars = { tab = '▸·', extends = '>', precedes = '<', trail = '·', nbsp = '¤' }
vim.opt.cursorline = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.number = true

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
})

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

-- ==========================================================================
-- Keymaps
-- ==========================================================================
local map = vim.keymap.set

-- Typo corrections
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- Very magic regex by default
map('n', '/', '/\\v', { desc = 'Search (very magic)' })
map('v', '/', '/\\v', { desc = 'Search (very magic)' })
map('c', '%s/', '%s/\\v', { desc = 'Substitute (very magic)' })

-- Reformat
map('n', 'Q', 'gqap', { desc = 'Reformat paragraph' })
map('v', 'Q', 'gq', { desc = 'Reformat selection' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Move through visual lines
map('n', 'j', 'gj')
map('n', 'k', 'gk')
map('n', '<Up>', 'gk')
map('n', '<Down>', 'gj')

-- F1 as escape (for keyboards where F1 is poorly placed)
map('i', '<F1>', '<Esc>')
map('v', '<F1>', '<Esc>')

-- Strip trailing whitespace
map('n', '<leader>W', [[:%s/\s\+$//<CR>:let @/=''<CR>]], { desc = 'Strip trailing whitespace' })

-- Tab width switching
map('n', '<leader>t2', '<cmd>setlocal shiftwidth=2 tabstop=2 softtabstop=2<CR>', { desc = 'Tab width 2' })
map('n', '<leader>t4', '<cmd>setlocal shiftwidth=4 tabstop=4 softtabstop=4<CR>', { desc = 'Tab width 4' })
map('n', '<leader>t8', '<cmd>setlocal shiftwidth=8 tabstop=8 softtabstop=8<CR>', { desc = 'Tab width 8' })

-- Emacs-style command line nav
map('c', '<C-a>', '<Home>')
map('c', '<C-e>', '<End>')
map('c', '<C-k>', '<C-u>')

-- Window navigation
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-k>', '<C-w><C-k>')
map('n', '<C-h>', '<C-w><C-h>')
map('n', '<C-l>', '<C-w><C-l>')

-- Window resize
map('n', '<C-S-j>', '<C-w>-', { desc = 'Shrink window' })
map('n', '<C-S-k>', '<C-w>+', { desc = 'Grow window' })
map('n', '<C-S-h>', '<C-w><lt>', { desc = 'Narrow window' })
map('n', '<C-S-l>', '<C-w>>', { desc = 'Widen window' })

-- Buffer management
map('n', '<leader>bn', '<cmd>bn<CR>', { desc = 'Next buffer' })
map('n', '<leader>bp', '<cmd>bp<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bb', '<cmd>b#<CR>', { desc = 'Alternate buffer' })
map('n', '<leader>c', '<cmd>bd<CR>', { desc = 'Close buffer' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

-- Format
map('n', '<leader>f', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format buffer' })

-- Comment (possible these needs to be <C-_> in some terminals
map('n', '<C-/>', 'gcc', { remap = true, desc = 'Toggle comment line' })
map('v', '<C-/>', 'gc', { remap = true, desc = 'Toggle comment selection' })

-- Fuzzy finder (fzf-lua)
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

-- ==========================================================================
-- Plugin setup
-- ==========================================================================

-- catppuccin
require('catppuccin').setup({ flavour = 'macchiato' })

-- fzf-lua
require('fzf-lua').setup({ 'default' })

-- treesitter: install parsers and enable highlighting
local ts_parsers = {
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
}
require('nvim-treesitter').install(ts_parsers)

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if pcall(vim.treesitter.language.inspect, lang) then
      vim.treesitter.start()
    end
  end,
})

-- treesitter textobjects
require('nvim-treesitter-textobjects').setup({
  select = {
    lookahead = true,
    set_jumps = true,
  },
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
  map({ 'x', 'o' }, mapping, function()
    require 'nvim-treesitter-textobjects.select'.select_textobject(query, 'textobjects')
  end, { desc = query })
end

local ts_movement = { -- brackets are automatically prepended, [ for prev, ] for next
  ['f'] = '@function.outer',
  ['c'] = '@class.outer',
}

for mapping, query in pairs(ts_movement) do
  local tsm = require('nvim-treesitter-textobjects.move')
  map({ 'n', 'x', 'o' }, ']' .. mapping, function()
    tsm.goto_next_start(query, 'textobjects')
  end, { desc = 'Next ' .. query })
  map({ 'n', 'x', 'o' }, (']' .. mapping):upper(), function()
    tsm.goto_next_end(query, 'textobjects')
  end, { desc = 'Next end of ' .. query })
  map({ 'n', 'x', 'o' }, '[' .. mapping, function()
    tsm.goto_previous_start(query, 'textobjects')
  end, { desc = 'Prev ' .. query })
  map({ 'n', 'x', 'o' }, ('[' .. mapping):upper(), function()
    tsm.goto_previous_end(query, 'textobjects')
  end, { desc = 'Prev end of ' .. query })
end

local tss = require('nvim-treesitter-textobjects.swap')
map('n', '<leader>a', function()
  tss.swap_next('@parameter.inner')
end, { desc = 'Swap with next parameter' })
map('n', '<leader>A', function()
  tss.swap_previous('@parameter.inner')
end, { desc = 'Swap with next parameter' })

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

-- mini.surround
require('mini.surround').setup()

-- mini.comment
require('mini.comment').setup()

-- which-key
require('which-key').setup({
  delay = 400,
  preset = 'modern',
  -- layout = { spacing = 4 },
  icons = { separator = '=' },
})

-- conform
-- Put this in .nvim.lua to override:
-- require('conform').formatters_by_ft.python = { 'other_python_formatter' }
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    ['_'] = { 'trim_whitespace' },
  },
})

-- ==========================================================================
-- LSP
-- ==========================================================================

-- Default config for all servers
vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Go
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

-- Python (ruff handles linting/formatting, pyright for types/completions/goto)
vim.lsp.config('pyright', {
  settings = {
    pyright = {
      disableOrganizeImports = true, -- ruff handles this
    },
    python = {
      analysis = {
        typeCheckingMode = 'basic',
      },
    },
  },
})

-- Terraform
vim.lsp.config('terraformls', {})

-- YAML with CloudFormation tags
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      customTags = {
        '!Ref',
        '!Sub',
        '!Sub sequence',
        '!GetAtt',
        '!GetAZs',
        '!ImportValue',
        '!Select sequence',
        '!Split sequence',
        '!Join sequence',
        '!Equals sequence',
        '!If sequence',
        '!Not sequence',
        '!Or sequence',
        '!And sequence',
        '!Condition',
        '!FindInMap sequence',
        '!Base64',
        '!Cidr sequence',
        '!Transform mapping',
      },
    },
  },
})

-- Enable all LSP servers
vim.lsp.enable({ 'gopls', 'lua_ls', 'ruff', 'pyright', 'terraformls', 'yamlls' })

-- LSP attach: enable completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end
  end,
})

-- ==========================================================================
-- Autocommands
-- ==========================================================================

-- CloudFormation filetype detection
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.yml', '*.yaml' },
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line and first_line:find('AWSTemplateFormatVersion') then
      vim.bo.filetype = 'yaml.cloudformation'
    end
  end,
})

vim.g.format_on_save = true

map('n', '<leader>tf',
  function()
    if vim.g.format_on_save then
      vim.g.format_on_save = false
    else
      vim.g.format_on_save = true
    end
  end,
  { desc = 'Toggle Format on save' })

-- Generic Format on Save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    if not vim.g.format_on_save then return end

    -- 1. Organize Imports: Only if the server explicitly supports it
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local caps = client.server_capabilities.codeActionProvider
      if
          type(caps) == 'table'
          and caps.codeActionKinds
          and vim.tbl_contains(caps.codeActionKinds, 'source.organizeImports')
      then
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        ---@diagnostic disable-next-line: inject-field
        params.context = { only = { 'source.organizeImports' } }
        local result = client:request_sync('textDocument/codeAction', params, 1000, 0)
        if result and result.result then
          for _, r in pairs(result.result) do
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
            elseif r.command then
              vim.lsp.util.execute_command(r.command)
            end
          end
        end
      end
    end

    -- 2. Format the file with conform
    require('conform').format({
      bufnr = args.buf,
      lsp_fallback = true,
      async = false,
    })
  end,
})

-- Disable swap/undo/shada for temp files
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
  pattern = { '/tmp/*', '/private/tmp/*', '*/shm/*' },
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
  end,
})

-- ==========================================================================
-- Terminal toggle
-- ==========================================================================
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  vim.cmd('botright 15split')
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_set_current_buf(term_buf)
  else
    vim.cmd('terminal')
    term_buf = vim.api.nvim_get_current_buf()
  end
  term_win = vim.api.nvim_get_current_win()
  vim.cmd('startinsert')
end

local function toggle_terminal_from_terminal()
  vim.cmd('stopinsert')
  toggle_terminal()
end

map('n', '<leader>tt', toggle_terminal, { desc = 'Toggle terminal' })
map('t', '<leader>tt', toggle_terminal_from_terminal, { desc = 'Toggle terminal' })
map('n', '<C-@>', toggle_terminal, { desc = 'Toggle terminal' })
map('t', '<C-@>', toggle_terminal_from_terminal, { desc = 'Toggle terminal' })
map('n', '<C-\\>', toggle_terminal, { desc = 'Toggle terminal' })
map('t', '<C-\\>', toggle_terminal_from_terminal, { desc = 'Toggle terminal' })
