return {
  -- General LSP config
  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = {
        enabled = true,
      },
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
      linters = {
        sqlfluff = {
          -- SQLFluff can't lint dbt projects through stdin.
          stdin = false,
        },
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
      formatters = {
        sqlfluff = {
          -- SQLFluff can't lint dbt projects through stdin.
          stdin = false,
          args = { "fix", "$FILENAME" },
        },
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
