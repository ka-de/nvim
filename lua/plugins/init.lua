return {
  {
    { "MunifTanjim/nui.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "ibhagwan/fzf-lua" },
    { "mfussenegger/nvim-dap" },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
    },
    {
      "stevearc/conform.nvim",
      event = "BufWritePre", -- format on save
      config = function()
        require "configs.conform"
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("nvchad.configs.lspconfig").defaults()
        require "configs.lspconfig"
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = { "vim", "lua", "vimdoc", "html", "css" },
      },
    },
  },
}
