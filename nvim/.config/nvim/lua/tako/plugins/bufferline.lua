return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            separator_style = "slope",
            indicator = {
                icon = '▎', -- this should be omitted if indicator style is not 'icon'
                style = 'underline',
            },
        },
    },
}
