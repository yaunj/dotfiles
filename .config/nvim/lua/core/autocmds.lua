-- Format on Save & Organize Imports
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    if not vim.g.format_on_save then return end

    -- 1. Organize Imports
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      local caps = client.server_capabilities.codeActionProvider
      if
        type(caps) == 'table'
        and caps.codeActionKinds
        and vim.tbl_contains(caps.codeActionKinds, 'source.organizeImports')
      then
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { 'source.organizeImports' } }
        local result = client:request_sync('textDocument/codeAction', params, 1000, args.buf)
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

    -- 2. Format with conform
    require('conform').format({
      bufnr = args.buf,
      lsp_fallback = true,
      async = false,
    })
  end,
})

-- CloudFormation filetype detection
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.yml', '*.yaml' },
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line and first_line:find('AWSTemplateFormatVersion') then vim.bo.filetype = 'yaml.cloudformation' end
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
