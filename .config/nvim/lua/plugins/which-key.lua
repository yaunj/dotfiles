return {
    'folke/which-key.nvim',
    event = 'VimEnter',  -- load before UI elements
    opts = {
        preset = 'modern',
        filter = function(mapping) return mapping.desc and mapping.desc ~= '' end,
        delay = 500,
        icons = {
            separator = '=',
            mappings = false,
            keys = {},
        },
        spec = {
            { '<leader>s', group = '[S]earch' },
            { '<leader>t', group = '[T]oggle' },
        },
    },
}
