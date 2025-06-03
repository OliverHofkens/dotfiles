return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "bedrock",
      providers = {
        bedrock = {
          model = "eu.anthropic.claude-3-7-sonnet-20250219-v1:0",
          aws_profile = "gorilla-tools-formulas",
          aws_region = "eu-west-1",
        },
      },
      file_selector = {
        provider = "fzf",
        provider_opts = {},
      },
      web_search_engine = {
        provider = "brave",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
    },
  },
}
