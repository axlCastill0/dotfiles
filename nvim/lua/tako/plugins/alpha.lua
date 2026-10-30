return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local fortune = require("alpha.fortune")

        -- Set header
        dashboard.section.header.val = {
            "                        ░▓                        ",
            "                       ░░▓▓                       ",
            "                      ░░▒░▓▓                      ",
            "                     ░░▒░▒░▓▓                     ",
            "                    ░░░░▒▒▒▒▒▓                    ",
            "                   ░░░░▒▒▒▒▒▒▒▓                   ",
            "                  ░░░▒▒▒▒▒▒▒▒░▒▓                  ",
            "                 ░▒▒▒░▒▒▒▒▒▒▒▒░▒▓                 ",
            "                ░▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▓                ",
            "               ░▒▒▒░▒▒░░░▒▒▒▒▒▒▒▒▒▓               ",
            "             ░░▒░▒▒▒░░▒░▒▒▒▒▒▒░▒▒▒▒▓▓             ",
            "            ░░▒░▒▒░░▒▒▒▒▒▒▒▒░▒▒▒░▒▒▒▓▓            ",
            "           ░░▒▒████████████████████░▒▓▓           ",
            "          ░░▒░░▒▓                ▓▒▒▒▒▓▓          ",
            "         ░░▒▒▓▓▒▒▓              ▒▒▒▓▓▒▒▓▓         ",
            "        ░░▒▒▒▓▓▓▒▒▓▓           ░▒▒▓▒▓▒▒▒▒▓        ",
            "       ░░▒▒▓▓▓▒▒▒▒▒▓▓        ▒░▒▒▓▓▒▓▒▒▓▒▒▒       ",
            "      ░░▒▓▓▓▓▓▓▒▒▒▒▒▒▓      ▒░▒▒▓▓▓▓▓▒▓▒▓▒▒▒      ",
            "     ░▒▒▓▓▒▓▓▓▓▒▒▓▓▒▓▒▓    ▒░▓▒▓▒▒▓▓▓▓▓▓▒▓▒▒▓     ",
            "    ░▒▒▓▓▓▒▒▓▓▓▒▓▒▒▓▒▓▒▓  ▒░▓▒▓▓▒▓▓▓▓▓▓▓▓▓▓▒▒▓    ",
            "   ░▓▒▓▓▓▓▒▓▓▓▓▒▒▓▓▓▒▒▓▒▓▒░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▓   ",
            " ▒░▓▓▒▒▓▓▓▓▓▒▓▓▓▓▓▓▒▓▓▓▓▒▒▓▒▒▓▒▒▓▓▓▓▓▒▓▒▓▓▓▓▓▓▓▓▓ ",
            "▒▓████████████████████████████████████████████████",
        }

        -- This overrides the default buttons section with an empty list
        dashboard.section.buttons.val = {}

        -- Set footer
        dashboard.section.footer.val = fortune()

        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.footer.opts.hl = "AlphaQuote"

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
