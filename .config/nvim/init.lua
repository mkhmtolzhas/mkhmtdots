-- Leader keys must be set before lazy.nvim loads so that plugin `keys` specs map
-- to the correct leader.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
