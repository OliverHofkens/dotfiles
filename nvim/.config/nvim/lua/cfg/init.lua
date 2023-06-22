-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("cfg.lsp")
require("cfg.signs")
require("cfg.line")
require("cfg.telescope")
require("cfg.filetree")
