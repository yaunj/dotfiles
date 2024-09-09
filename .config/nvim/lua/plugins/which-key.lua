return {
    'folke/which-key.nvim',
    opts = {
        preset = 'modern',
        filter = function(mapping) return mapping.desc and mapping.desc ~= '' end,
        delay = 1000,
        icons = {
            separator = '=',
            mappings = false,
            keys = {},
        },
    },
}
