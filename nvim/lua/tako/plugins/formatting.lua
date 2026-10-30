return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                python = { "ruff_format", "ruff_organize_imports" },
                sql = { "sqlfluff" },
            },
            formatters = {
                sqlfluff = {
                    args = { "format", "--dialect=ansi", "-" },
                    -- conform's bundled config requires a .sqlfluff/pyproject.toml root
                    require_cwd = false,
                },
            },
            format_on_save = {
                lsp_format = "fallback",
                async = false,
                timeout_ms = 2000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_format = "fallback",
                async = false,
                timeout_ms = 2000,
            })
        end, { desc = "Format file or range" })
    end,
}
