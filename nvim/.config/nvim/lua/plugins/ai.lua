return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    init = function()
      local proc = io.popen("aws configure export-credentials --profile gorilla-tools-formulas")
      local out = proc:read("*a")

      local creds = vim.json.decode(out)

      vim.env.BEDROCK_KEYS =
        string.format("%s,%s,%s,%s", creds["AccessKeyId"], creds["SecretAccessKey"], "eu-west-1", creds["SessionToken"])
    end,
    opts = {
      provider = "bedrock",
      bedrock = {
        model = "eu.anthropic.claude-3-7-sonnet-20250219-v1:0",
      },
      file_selector = {
        provider = "fzf",
        provider_opts = {},
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
