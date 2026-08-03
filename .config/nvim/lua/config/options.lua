local opt = vim.opt

-- Indentation: 4-space soft tabs.
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- Line numbers (absolute on the cursor line, relative elsewhere).
opt.number = true
opt.relativenumber = true

opt.fillchars = { eob = " " }

-- Note: the colorscheme is owned by lua/plugins/colortheme.lua (catppuccin),
-- which loads after this file and would override any `:colorscheme` set here.
