return {
  {
    "simrat39/rust-tools.nvim",
    enabled = false,
    lazy = true, -- rust-tools will be loaded by mason-lspconfig
    opts = {
      -- rust-tools options
      tools = {
        inlay_hints = {
          show_parameter_hints = false,
          only_current_line = true,
          highlight = "LineNr",
        },
      },
      -- lspconfig options
      server = {
        settings = {
          ["rust-analyzer"] = { cargo = { allFeatures = true } },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
}
