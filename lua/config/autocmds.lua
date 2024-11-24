-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "txt" },
    callback = function()
      -- 禁用 Copilot 的建议
      local copilot = require("copilot")
      if copilot.get_status and copilot.get_status() then
        copilot.disable()
      end

      -- 禁用 codeium
      local codeium = require("codeium")
      if codeium and codeium.disable then
        codeium.disable()
      end
    end,
  })
end

return M
