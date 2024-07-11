vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  --[[ ⚠️ Just use :Neotree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    version = "*",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    opts = {
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
        special_files = {},
      },
      actions = { open_file = { quit_on_open = false } },
      filters = { dotfiles = false, git_ignored = false, custom = { "^.DS_Store$", "^\\.git$" } },
      git = { enable = true, ignore = true, timeout = 500 },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
  ]]
  --
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function(_, opts)
      table.insert(opts.sources, { name = "codeium" })
      require("cmp").setup(opts)
    end,

    dependencies = {
      {
        "jcdickinson/codeium.nvim",
        config = function()
          require("codeium").setup {}
        end,
      },
    },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  {
    import = "plugins",
  },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

--vim.cmd.colorscheme "catppuccin-macchiato"

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

require "neo-tree"

local luasnip = require "luasnip"
local cmp = require "cmp"

cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    --{ name = "codeium" },
  },
}

require("codeium").setup {}

require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,

    -- disable = {"c", "rust"},
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    additional_vim_regex_highlighting = false,
  },
}

require("nvim-web-devicons").setup {
  color_icons = true,
  default = true,
  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true,
  -- same as `override` but specifically for overrides by filename
  -- takes effect when `strict` is true
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore",
    },
  },
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log",
    },
  },
  -- same as `override` but specifically for operating system
  -- takes effect when `strict` is true
  override_by_operating_system = {
    ["apple"] = {
      icon = "",
      color = "#A2AAAD",
      cterm_color = "248",
      name = "Apple",
    },
  },
}

require("fzf-lua").setup {}

--[[
require("mason").setup {
  ui = {
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    },
  },
}

require("mason-lspconfig").setup()
]]
--

--[[
local rt = require "rust-tools"

rt.setup {
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
}

-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = "",
  })
end

sign { name = "DiagnosticSignError", text = "" }
sign { name = "DiagnosticSignWarn", text = "" }
sign { name = "DiagnosticSignHint", text = "" }
sign { name = "DiagnosticSignInfo", text = "" }

vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.cmd [[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]]
--

require("catppuccin").setup {
  flavour = "latte", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = false,
    neotree = true,
    treesitter = true,
    notify = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
  },
}

-- Hop
require("hop").setup {
  keys = "etovxqpdygfblzhckisuran",
  jump_on_sole_occurrence = false,
  case_insensitive = false,
  create_hl_autocmd = true,
  uppercase_labels = false,
  current_line_only = false,
  multi_windows = true,
}

vim.cmd "command! Ha HopAnywhere"
vim.cmd "command! Hac HopAnywhereAC"
vim.cmd "command! Hbc HopAnywhereBC"
vim.cmd "command! Hl HopAnywhereCurrentLine"
vim.cmd "command! Hlac HopAnywhereCurrentLineAC"
vim.cmd "command! Hlbc HopAnywhereCurrentLineBC"
vim.cmd "command! Hmw HopAnywhereMW"

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

vim.notify = require "notify"

-- 24-bit color
vim.opt.termguicolors = true

require("lspconfig").lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
}
