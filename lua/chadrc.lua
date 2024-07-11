-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua
---@type ChadrcConfig
---@class M
M = {}

M.ui = {
  theme = "aquarium",

  hl_override = {
    Pmenu = {
      bg = "white",
    },

    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
  },
}

return M
