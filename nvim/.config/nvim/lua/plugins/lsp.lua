return {
  -- General LSP config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Enabled by default by the LazyVim Python Extras
          enabled = false,
        },
        ty = {
          enabled = true,
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
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "ty",
        "yamlls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        rst = { "rstcheck", "proselint", "write_good" },
        rust = { "clippy" },
        ["*"] = { "typos" },
      },
      linters = {
        sqlfluff = {
          args = { "lint", "--templater=jinja", "--format=json" },
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
        rst = { "docstrfmt", "trim_whitespace" },
        yaml = {},
      },
      formatters = {
        sqlfluff = {
          args = { "fix", "--templater", "jinja", "-" },
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
