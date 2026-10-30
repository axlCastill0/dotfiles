return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
        "windwp/nvim-ts-autotag"
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")

        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- ensure these language parsers are installed
            ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "python",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })

        -- use bash parser for zsh files
        vim.treesitter.language.register("bash", "zsh")

        -- parsers are compiled locally, so without a C compiler :TSUpdate produces
        -- nothing and highlighting silently falls back to regex syntax. Fail loudly
        -- instead. Compiler list mirrors nvim-treesitter.install.compilers.
        local candidates = { "cc", "gcc", "clang", "cl", "zig" }
        if vim.env.CC and vim.env.CC ~= "" then
            table.insert(candidates, 1, vim.env.CC)
        end
        local has_cc = false
        for _, cc in ipairs(candidates) do
            if vim.fn.executable(cc) == 1 then
                has_cc = true
                break
            end
        end
        if not has_cc then
            vim.notify(
                "nvim-treesitter: no C compiler on PATH (tried cc, gcc, clang, cl, zig). "
                    .. "Parsers cannot be built; syntax highlighting will fall back to regex.",
                vim.log.levels.WARN
            )
        end
    end,
}
