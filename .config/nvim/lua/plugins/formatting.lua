return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
            mode = '',
            desc = '[F]ormat buffer',
        },
        {
            '<leader>tf',
            function()
                if vim.g.disable_autoformat then
                    vim.g.disable_autoformat = false
                else
                    vim.g.disable_autoformat = true
                end
            end,
            mode = 'n',
            desc = '[T]oggle auto[F]ormatting',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Check if format on save is disabled
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end
        end,
        formatters_by_ft = {
            lua = { 'stylua' },
            go = { 'goimports', 'gofmt' },
            python = function(bufnr)
                --local pythonconf = vim.fs.joinpath(vim.fs.root('.', 'pyproject.toml'), 'pyproject.toml')
                local pythonconf = vim.fs.joinpath(
                    vim.fs.root(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), 'pyproject.toml'),
                    'pyproject.toml'
                )
                confcontent = vim.fn.readfile(pythonconf)
                if vim.fn.match(confcontent, 'tool.ruff') ~= -1 then
                    -- use ruff
                    vim.print('Formatting with ruff')
                    return { 'ruff_format' }
                elseif vim.fn.match(confcontent, 'tool.black') ~= 1 then
                    -- use isort and black
                    vim.print('Formatting with isort + black')
                    return { 'isort', 'black' }
                end

                if require('conform').get_formatter_info('ruff_format', bufnr).available then
                    return { 'ruff_format' }
                else
                    return { 'isort', 'black' }
                end
            end,
            ['_'] = { 'trim_whitespace' },

            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}
