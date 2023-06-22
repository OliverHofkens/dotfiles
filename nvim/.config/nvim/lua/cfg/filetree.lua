-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    custom = { "^.git$" }
  },
  actions = {
    open_file = {
        quit_on_open = true,
        window_picker = {
            enable = false,
        }
    }
  }
})

vim.keymap.set('n', '<c-b>', ':NvimTreeOpen<cr>')
