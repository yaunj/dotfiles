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

-- F1 as escape
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

-- Comments
map('n', '<C-/>', 'gcc', { remap = true, desc = 'Toggle comment line' })
map('v', '<C-/>', 'gc', { remap = true, desc = 'Toggle comment selection' })

-- Convenience when using omni completion
map('i', '<C-o>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    return '<C-o>'
  end
end, { expr = true })

-- Toggle Format on Save
vim.g.format_on_save = true
map('n', '<leader>tf', function()
  vim.g.format_on_save = not vim.g.format_on_save
  print('Format on save: ' .. tostring(vim.g.format_on_save))
end, { desc = 'Toggle Format on Save' })

-- ==========================================================================
-- Unimpaired-style navigation (Replacement for vim-unimpaired)
-- ==========================================================================
map('n', '[b', '<cmd>bp<CR>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>bn<CR>', { desc = 'Next buffer' })
map('n', '[q', '<cmd>cprev<CR>', { desc = 'Prev quickfix' })
map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix' })
map('n', '[l', '<cmd>lprev<CR>', { desc = 'Prev loclist' })
map('n', ']l', '<cmd>lnext<CR>', { desc = 'Next loclist' })

-- ==========================================================================
-- Helper commands (Replacement for vim-eunuch)
-- ==========================================================================
vim.api.nvim_create_user_command('SudoWrite', 'w !sudo tee % > /dev/null', { desc = 'Write as sudo' })
vim.api.nvim_create_user_command('Rename', function(opts)
  local old_name = vim.api.nvim_buf_get_name(0)
  local new_name = opts.args

  -- If new_name is just a filename, keep it in the same directory
  if not new_name:match('[/\\]') then new_name = vim.fn.fnamemodify(old_name, ':h') .. '/' .. new_name end

  -- Rename the file on disk
  local success, err = os.rename(old_name, new_name)

  if success then
    -- Update the buffer name in Neovim and reload it
    vim.api.nvim_buf_set_name(0, new_name)
    vim.cmd('edit!')
    vim.api.nvim_command('redrawstatus')
  else
    vim.notify('Rename failed: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
  end
end, { nargs = 1, complete = 'file', desc = 'Rename current file and buffer' })

-- ==========================================================================
-- Terminal Toggle
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

map('n', '<leader>tt', toggle_terminal, { desc = 'Toggle terminal' })
map('t', '<leader>tt', function()
  vim.cmd('stopinsert')
  toggle_terminal()
end, { desc = 'Toggle terminal' })
map('n', '<C-@>', toggle_terminal, { desc = 'Toggle terminal' })
map('t', '<C-@>', function()
  vim.cmd('stopinsert')
  toggle_terminal()
end, { desc = 'Toggle terminal' })
map('n', '<C-\\>', toggle_terminal, { desc = 'Toggle terminal' })
map('t', '<C-\\>', function()
  vim.cmd('stopinsert')
  toggle_terminal()
end, { desc = 'Toggle terminal' })
