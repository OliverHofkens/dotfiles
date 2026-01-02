return {
  -- Completion config
  "saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        lsp = {
          -- Ty will suggest anything that can be imported,
          -- which fills up the entire blink buffer with noise
          max_items = 25,
        },
      },
    },
  },
}
