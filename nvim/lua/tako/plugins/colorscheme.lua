return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme tokyonight")
  -- end
  -- "nyoom-engineering/oxocarbon.nvim",
  -- priority = 1000,
  -- config = function()
  --   vim.opt.background = "dark" -- set this to dark or light
  --   vim.cmd("colorscheme oxocarbon")
    -- Uncomment for transparent bg
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end
}
