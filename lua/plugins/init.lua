return {
  {
    -- neovim-ayu
    --{ "Shatur/neovim-ayu" },

    -- Completion framework:
    --{ "hrsh7th/nvim-cmp" },

    -- LSP completion source:
    --{ "hrsh7th/cmp-nvim-lsp" },

    -- Useful completion sources:
    --{ "hrsh7th/cmp-nvim-lua" },
    --{ "hrsh7th/cmp-nvim-lsp-signature-help" },
    --{ "hrsh7th/cmp-vsnip" },
    --{ "hrsh7th/cmp-path" },
    --{ "hrsh7th/cmp-buffer" },
    --{ "hrsh7th/vim-vsnip" },

    -- Mason
    --{ "williamboman/mason.nvim" },
    --{ "williamboman/mason-lspconfig.nvim" },

    -- rust-tools
    --{ "simrat39/rust-tools.nvim" },

    -- nui
    { "MunifTanjim/nui.nvim" },

    -- plenary
    { "nvim-lua/plenary.nvim" },

    -- nvim-web-devicons
    { "nvim-tree/nvim-web-devicons" },

    -- nvim-dap
    --{ "mfussenegger/nvim-dap" },

    { -- fzf-lua
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
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
