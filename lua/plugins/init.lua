return {{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
}, {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- format on save
    config = function()
        require "configs.conform"
    end
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require("nvchad.configs.lspconfig").defaults()
        require "configs.lspconfig"
    end
}, {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {"lua-language-server", "stylua", "html-lsp", "css-lsp", "prettier"}
    }
}, {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {"vim", "lua", "vimdoc", "html", "css"}
    }
}}
