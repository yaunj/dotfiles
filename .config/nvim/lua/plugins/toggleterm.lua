return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup()
        vim.keymap.set('n', '<C-t>', ':ToggleTerm<CR>')
        vim.keymap.set(
            'v',
            '<space>ts',
            function() require('toggleterm').send_lines_to_terminal('single_line', true, { args = vim.v.count }) end,
            { desc = 'Send line to terminal' }
        )
    end,
}
