return {
    -- "folke/tokyonight.nvim",
    -- priority = 1000,
    -- config = function()
        -- vim.cmd("colorscheme tokyonight")
        -- end
        "nyoom-engineering/oxocarbon.nvim",
        priority = 1000,
        config = function()
            vim.opt.background = "dark" -- set this to dark or light
            vim.cmd("colorscheme oxocarbon")
            -- alpha colors
            vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#A91B0D" })
            vim.api.nvim_set_hl(0, "AlphaQuote", { fg = "#680C07" })
        end
    }
