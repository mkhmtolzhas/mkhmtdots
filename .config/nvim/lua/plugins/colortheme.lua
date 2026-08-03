local palette = vim.fn.expand("~/.cache/matugen/nvim-base16.lua")

local function has_palette()
  return (vim.uv or vim.loop).fs_stat(palette) ~= nil
end

return {
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    cond = has_palette,
    config = function()
      local function apply()
        local ok, colors = pcall(dofile, palette)
        if ok and type(colors) == "table" then
          require("base16-colorscheme").setup(colors)
          pcall(function()
            require("lualine").setup({ options = { theme = "auto" } })
          end)
        end
      end
      apply()
      _G.MatugenReload = apply
    end,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    cond = function()
      return not has_palette()
    end,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
