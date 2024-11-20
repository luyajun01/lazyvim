-- lua/config/python.lua

local M = {}

M.setup = function()
  -- Python 配置
  local conda_prefix = os.getenv("CONDA_PREFIX")
  if conda_prefix then
    vim.g.python3_host_prog = conda_prefix .. "/bin/python"
  else
    vim.notify("Conda environment not activated", vim.log.levels.WARN)
  end

  -- 设置 Python 缩进
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
    end,
  })
end

M.plugins = {
  -- LSP 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpython = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
      setup = {
        basedpython = function(_, opts)
          local lsp_utils = require("lazyvim.util").lsp
          lsp_utils.on_attach(function(client, buffer)
            -- 自定义 on_attach 函数
            vim.keymap.set(
              "n",
              "<leader>pd",
              vim.lsp.buf.definition,
              { buffer = buffer, desc = "Python: Goto Definition" }
            )
            vim.keymap.set(
              "n",
              "<leader>pr",
              vim.lsp.buf.references,
              { buffer = buffer, desc = "Python: Find References" }
            )
          end)
          return false -- 让 LazyVim 完成设置
        end,
      },
    },
  },

  -- Treesitter 配置
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python" })
      end
    end,
  },

  -- Mason.nvim 配置
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "basedpython", "black", "isort", "pyright" })
    end,
  },

  -- Null-ls 配置 (用于代码格式化和诊断)
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.black,
        nls.builtins.formatting.isort,
      })
    end,
  },

  -- 可选：添加 Python 测试运行器，例如 neotest
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
        },
      },
    },
  },
}

return M
