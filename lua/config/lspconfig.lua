local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.rime_ls.setup({
  init_options = {
    enabled = false,
    shared_data_dir = "~/Library/Rime",
    user_data_dir = "~/Library/Rime",
    --log_dir = "~/.local/share/rime-ls",
  },
  capabilities = capabilities,
})
