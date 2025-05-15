-- Function to fetch AWS credentials asynchronously and reload the plugin
local function fetch_bedrock_keys()
  local job = require("plenary.job")
  job
    :new({
      command = "aws",
      args = { "configure", "export-credentials", "--profile", "gorilla-tools-formulas" },
      on_exit = function(j, return_val)
        -- Schedule all UI operations and plugin reloading to run in the main event loop
        vim.schedule(function()
          if return_val == 0 then
            local result = table.concat(j:result(), "")
            local success, creds = pcall(vim.json.decode, result)
            if success and creds then
              -- Update environment variable
              vim.env.BEDROCK_KEYS = string.format(
                "%s,%s,%s,%s",
                creds["AccessKeyId"],
                creds["SecretAccessKey"],
                "eu-west-1",
                creds["SessionToken"]
              )

              -- Reload the Avante plugin to use the new credentials
              local avante_loaded = package.loaded["avante"]
              if avante_loaded then
                -- Unload the plugin modules to force reinitialization
                package.loaded["avante"] = nil
                package.loaded["avante.init"] = nil
                package.loaded["avante.config"] = nil

                -- Try to reinitialize the plugin
                pcall(function()
                  require("avante").setup()
                  vim.notify("Avante plugin reloaded with fresh credentials", vim.log.levels.INFO)
                end)
              else
                vim.notify("Bedrock credentials refreshed (plugin not yet loaded)", vim.log.levels.INFO)
              end
            else
              vim.notify("Failed to parse AWS credentials", vim.log.levels.ERROR)
            end
          else
            vim.notify("Failed to fetch AWS credentials", vim.log.levels.ERROR)
          end
        end)
      end,
    })
    :start()
end

-- Function to setup periodic credential refresh
local function setup_credential_refresh()
  -- Initial fetch
  fetch_bedrock_keys()

  -- Set up timer for periodic refresh (every 30 minutes)
  local timer = vim.loop.new_timer()
  local refresh_interval = 30 * 60 * 1000 -- 30 minutes in milliseconds
  timer:start(refresh_interval, refresh_interval, function()
    -- Use vim.schedule to ensure the callback runs in the main Neovim event loop
    fetch_bedrock_keys()
  end)

  -- Store timer in global state to prevent garbage collection
  if not _G.bedrock_refresh_timer then
    _G.bedrock_refresh_timer = timer
  end
end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    init = function()
      -- Don't block startup, schedule the credential setup
      vim.schedule(setup_credential_refresh)
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
