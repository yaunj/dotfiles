return {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            integrations = {
                treesitter = not Config.old_nvim,
                semantic_tokens = not Config.old_nvim,
            },
        })

        local toggle_background = function()
            local bg = 'dark'
            if vim.o.background == 'dark' then bg = 'light' end
            vim.o.background = bg
        end

        vim.keymap.set(
            'n',
            '<leader>tb',
            toggle_background,
            { silent = true, noremap = true, desc = '[T]oggle [B]ackground' }
        )
        vim.cmd([[colorscheme catppuccin]])

        -- if not Config.old_nvim then
        --     -- Automatic switch to light mode during office hours
        --     local timer = vim.uv.new_timer()
        --     timer:start(1000, 60000, vim.schedule_wrap(function()
        --         local bg = "dark"
        --         local hour = os.date("%H")
        --         if hour > "09" and hour < "17" then
        --             bg = "light"
        --         end
        --         vim.o.background = bg
        --     end))
        -- end
    end,
}
