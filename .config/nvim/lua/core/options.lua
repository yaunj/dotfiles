vim.o.backspace = 'indent,eol,start'
vim.o.wildmenu = true
vim.o.incsearch = true

vim.o.mouse = 'a'

-- Encoding {{{
vim.o.fileformat = 'unix' -- Always UNIX line endings
vim.o.encoding = 'utf-8' -- Somehow not default under Windows :(
vim.o.fileencoding = 'utf-8'

-- }}}

-- Appearance {{{
-- move to colorscheme plugin
--vim.o.bg=light
--try
--    colorscheme PaperColor
--catch
--    colorscheme zenburn
--endtry

vim.o.showmatch = true -- indicate matching paren in insert mode
vim.o.list = true
vim.o.listchars = 'tab:▸·,extends:>,precedes:<,trail:·,nbsp:¤'

vim.o.cursorline = true

-- Statusline format is set in the yaunj_statusline plugin
vim.o.laststatus = 2 -- always show status line
vim.o.wildmode = 'longest:full,full' -- stop on longest common match, fallback to full
-- }}}
-- Searching {{{
vim.o.hlsearch = true -- hilight search matches
vim.o.ignorecase = true -- ignore case in search patterns
vim.o.smartcase = true -- ... unless the pattern has capitals
vim.o.gdefault = true -- use /g as default for s///-expressions

vim.opt.isfname:remove('=') -- ignore = in pathnames when using gf
-- }}}
-- Indenting {{{
vim.o.smartindent = true -- Smarter than autoindent ;)
vim.o.softtabstop = -1 -- backspace over softtabs
vim.o.shiftwidth = 4 -- spaces for indent
vim.o.expandtab = true -- spaces, not tabs

-- }}}
-- Formatting and textlength {{{
vim.o.formatoptions = 'jcroql'
--vim.o.textwidth=80

-- }}}
-- History and undoing {{{
--local current_os = vim.loop.os_uname().sysname
-- seems like the defaults on nvim are sane
--if current_os:match('Windows') then
--	vim.o.undodir='~/vimfiles/var/undo/'
--else
--	vim.o.undodir = '~/.vim/var/undo/'
--end
vim.o.undofile = true

-- }}}
-- Misc settings {{{
vim.o.visualbell = true -- don't make noise
vim.o.hidden = true -- change buffer without saving

-- Disable swap, viminfo and undofile for tempfiles, and files in shared memory
local swapundoskip = vim.api.nvim_create_augroup('swapundoskip', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
    pattern = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*',
    group = swapundoskip,
    --command = 'setlocal noswapfile viminfo=',
    callback = function(_)
        vim.bo.swapfile = false
        vim.bo.viminfo = ''
    end,
})
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*',
    group = swapundoskip,
    --command = 'setlocal noundofile',
    callback = function(_) vim.bo.undofile = false end,
})

-- }}}
