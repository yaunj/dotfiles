vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function kmap(mode, from, to, opts)
    local actual_opts = { noremap = true, silent = true }
    if opts then
        for k, v in pairs(opts) do
            actual_opts[k] = v
        end
    end
    vim.keymap.set(mode, from, to, actual_opts)
end

local function cmap(from, to, opts) kmap('c', from, to, opts) end
local function imap(from, to, opts) kmap('i', from, to, opts) end
local function nmap(from, to, opts) kmap('n', from, to, opts) end
local function tmap(from, to, opts) kmap('t', from, to, opts) end
local function vmap(from, to, opts) kmap('v', from, to, opts) end

-- Common typos
kmap('n', ':W', ':w', { noremap = false })
kmap('n', ':Q', ':q', { noremap = false })

-- Sensible regexes
nmap('/', '/\\v')
vmap('/', '/\\v')

-- Ctrl-tab to correctly indent line in insert mode
imap('<C-tab>', '<C-o>V=')

-- reformat text
nmap('Q', 'gqap', { desc = '' })
vmap('Q', 'gq')

-- clear hilighting from search
nmap('<leader><Space>', ':nohl<CR>')

-- <leader>p as pastetoggle
nmap('<leader>p', ':setlocal paste! paste?<cr>', { desc = 'Toggle paste' })

-- Up and down moves through visible lines, not over them.
nmap('j', 'gj')
nmap('k', 'gk')
nmap('<up>', 'gk')
nmap('<down>', 'gj')

-- On some keyboards esc is easy to miss
imap('<F1>', '<ESC>')
vmap('<F1>', '<ESC>')

-- clean trailing whitespace
nmap('<leader>W', ":%s/\\s\\+$//<CR>:let @/=''<CR>", { desc = 'Clean trailing space' })

-- Change tab settings
nmap('<leader>t2', ':setlocal shiftwidth=2 tabstop=2 softtabstop=2<CR>', { desc = 'Use 2 as tabstop' })
nmap('<leader>t4', ':setlocal shiftwidth=4 tabstop=4 softtabstop=4<CR>', { desc = 'Use 4 as tabstop' })
nmap('<leader>t8', ':setlocal shiftwidth=8 tabstop=8 softtabstop=8<CR>', { desc = 'Use 8 as tabstop' })

-- Emacs bindings for command line
cmap('<C-A>', '<Home>')
cmap('<C-E>', '<End>')
cmap('<C-K>', '<C-U>')

-- Move between windows
nmap('<C-j>', '<C-W>j')
nmap('<C-k>', '<C-W>k')
nmap('<C-h>', '<C-W>h')
nmap('<C-l>', '<C-W>l')

-- Buffers
nmap('<leader>bn', ':bn<CR>', { desc = '[B]uffer [N]ext' })
nmap('<leader>bp', ':bp<CR>', { desc = '[B]uffer [P]rev' })
nmap('<leader>bb', ':b#<CR>', { desc = '[B]uffer [B]ack to alternate' })
nmap('<leader>c', ':bd<CR>')

-- Terminal mappings
tmap('<ESC>', '<C-\\><C-N>')
