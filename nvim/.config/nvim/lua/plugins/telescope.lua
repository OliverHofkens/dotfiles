return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
  },
  config = function()
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
    })

    -- Keymap
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>f', function() builtin.find_files({hidden = true}) end, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>c', builtin.commands, { desc = 'Telescope commands' })
    vim.keymap.set('n', '<leader>q', builtin.quickfix, { desc = 'Telescope quickfix' })
    vim.keymap.set('n', '<leader>r', builtin.lsp_references, { desc = 'Telescope references' })
  end
}
