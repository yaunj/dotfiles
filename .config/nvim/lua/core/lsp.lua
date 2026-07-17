-- Default config for all servers
vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Enable servers
-- Configs in ~/.config/nvim/lsp/
vim.lsp.enable({ 'gopls', 'lua_ls', 'ruff', 'pyright', 'taplo', 'terraformls', 'yamlls' })

-- LSP attach: enable completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end
  end,
})
