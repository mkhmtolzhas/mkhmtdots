return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- codex.nvim is lazy-loaded; guard so lualine still works if it is absent.
    pcall(function()
      require("codex").status()
    end)
    require("lualine").setup({
      options = {
        theme = "auto",
      },
    })
  end,
}
