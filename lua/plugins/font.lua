return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        -- 确保 treesitter 高亮能正确显示中文
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- 设置字体相关选项
      defaults = {
        autocmd = {
          {
            "VimEnter",
            "*",
            function()
              vim.o.guifont = "SimSun:h12"
              vim.opt.guifontwide = "SimSun:h12"
            end,
          },
        },
      },
    },
  },
}
