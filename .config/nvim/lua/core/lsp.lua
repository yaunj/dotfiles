-- Default config for all servers
vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Server specific settings
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

vim.lsp.config('pyright', {
  settings = {
    pyright = { disableOrganizeImports = true },
    python = { analysis = { typeCheckingMode = 'basic' } },
  },
})

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

-- Enable servers
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
