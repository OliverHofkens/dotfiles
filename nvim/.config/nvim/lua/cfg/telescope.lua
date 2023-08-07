local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      ".git/",
      ".tox/",
      "node_modules/",
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {},
  },
})
require("telescope").load_extension("fzf")

vim.keymap.set('n', '<c-p>', ':Telescope find_files hidden=true theme=get_ivy<cr>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep theme=get_ivy<cr>')
