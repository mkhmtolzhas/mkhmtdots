-- nvim-treesitter `main` branch (the `master` branch is archived).
-- The new API has no `configs.setup()`: parsers are installed via
-- `require("nvim-treesitter").install()` and highlighting/indentation are the
-- built-in `vim.treesitter.*` features enabled per buffer.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ensure_installed = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "html",
      "css",
      "json",
      "bash",
    }

    -- The `main` branch compiles parsers with the tree-sitter CLI. Only trigger
    -- installs when it is available, otherwise every startup would retry failing
    -- downloads. Already-compiled parsers still highlight without the CLI.
    if vim.fn.executable("tree-sitter") == 1 then
      require("nvim-treesitter").install(ensure_installed)
    else
      vim.notify(
        "nvim-treesitter (main): `tree-sitter` CLI not found. "
          .. "Install it (e.g. `pacman -S tree-sitter-cli`) then run `:TSUpdate`.",
        vim.log.levels.WARN
      )
    end

    -- Enable treesitter highlighting + indentation for any buffer whose parser
    -- is installed. No hardcoded filetype list: `vim.treesitter.start` fails
    -- (caught by pcall) when no parser exists, so we only opt in where it works.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
