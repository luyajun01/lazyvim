-- return {
--   "liubianshi/cmp-lsp-rimels",
--   keys = { { "<localleader>f", mode = "i" } },
--   cmd = { "/Users/luyajun/.local/bin/rime_ls" },
--   rime_user_dir = "/Users/luyajun/Library/Rime",
--   shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport",
--   config = function()
--     vim.system({ "rime_ls", "--listen", "127.0.0.1:9257" })
--     require("rimels").setup({
--       cmd = vim.lsp.rpc.connect("127.0.0.1", 9257),
--     })
--   end,
-- }
--
--

-- ~/.config/nvim/lua/config/lazy.lua

return {
  "liubianshi/cmp-lsp-rimels",
  dependencies = {
    --"wlh320/rime-ls",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
  }, -- 确保 rimels 插件作为依赖被安装
  keys = {
    {
      "<localleader>f",
      function()
        -- 手动触发补全
        require("cmp").complete()
      end,
      mode = "i",
      desc = "触发 Rime 补全",
    },
  },
  config = function()
    -- 检查 rime_ls 是否已在运行
    local handle = io.popen("lsof -i :9257")
    local result = handle:read("*a")
    handle:close()

    if not result or result == "" then
      vim.notify("rime_ls 未运行，请确保已通过 launchd 或其他方式启动。", vim.log.levels.WARN)
    else
      vim.notify("rime_ls 已在运行。", vim.log.levels.INFO)
    end

    -- 配置 rimels
    require("rimels").setup({
      -- cmd = { "127.0.0.1", 9257 }, -- 使用正确的连接方式
      cmd = { "/Users/luyajun/.local/bin/rime_ls" },
      --cmd = vim.lsp.rpc.connect("127.0.0.1", 9257), -- 使用正确的连接方式
      rime_user_dir = "/Users/luyajun/Library/Rime",
      shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport",
    })
  end,
}
