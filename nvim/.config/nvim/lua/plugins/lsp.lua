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
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        rust = { "clippy" },
      },
    },
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = {},
        python = { "ruff_format", "ruff_organize_imports" },
        yaml = {},
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
