return {
  -- General LSP config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              pythonPath = ".venv/bin/python3",
            },
          },
        },
      },
    },
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
        yaml = { "yamlfmt" },
      },
    },
  },
  -- Language specific
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = {
              allTargets = false,
              targets = { "arm64-apple-darwin" },
            },
          },
        },
      },
    },
  },
}
