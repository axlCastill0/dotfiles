return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            sql = { "sqlfluff" },
        }

        -- the trailing "-" is the stdin marker; without it sqlfluff reads nothing
        lint.linters.sqlfluff.args = {
            "lint",
            "--format=json",
            "--dialect=ansi",
            "-",
        }

        local lint_group = vim.api.nvim_create_augroup("tako-lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_group,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}
