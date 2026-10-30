return {
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            -- v2: installed servers are enabled automatically via `vim.lsp.enable()`.
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "vtsls",
                    "eslint",
                    "pyright",
                    "ruff",
                    "prismals",
                    "tailwindcss",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            vim.diagnostic.config({
                virtual_text = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("tako-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc, silent = true })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Show references")
                    map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show implementations")
                    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show type definitions")
                    map("n", "K", vim.lsp.buf.hover, "Hover docs")
                    map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
                    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
                    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
                    map("n", "<leader>cR", "<cmd>LspRestart<CR>", "Restart LSP")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.name == "ruff" then
                        -- let pyright own hover for python buffers
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })

            -- shared defaults for every server
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            vim.lsp.config("vtsls", {
                settings = {
                    typescript = {
                        inlayHints = {
                            parameterNames = { enabled = "literals" },
                            parameterTypes = { enabled = true },
                            variableTypes = { enabled = false },
                            propertyDeclarationTypes = { enabled = true },
                            functionLikeReturnTypes = { enabled = true },
                            enumMemberValues = { enabled = true },
                        },
                        preferences = { importModuleSpecifier = "non-relative" },
                        updateImportsOnFileMove = { enabled = "always" },
                    },
                    javascript = {
                        inlayHints = {
                            parameterNames = { enabled = "literals" },
                            parameterTypes = { enabled = true },
                        },
                    },
                },
            })

            local eslint_on_attach = vim.lsp.config.eslint.on_attach
            vim.lsp.config("eslint", {
                on_attach = function(client, bufnr)
                    if eslint_on_attach then
                        eslint_on_attach(client, bufnr)
                    end
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "LspEslintFixAll",
                    })
                end,
            })

            vim.lsp.config("pyright", {
                settings = {
                    pyright = {
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
            })

            vim.lsp.config("tailwindcss", {
                filetypes = {
                    "html",
                    "css",
                    "scss",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "svelte",
                    "vue",
                },
            })
        end,
    },
}
