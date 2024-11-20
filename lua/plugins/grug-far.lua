return {
  "MagicDuck/grug-far.nvim",
  config = function()
    require("grug-far").setup({
      -- 基础配置
    })
  end,
  -- 可选:指定加载条件
  event = "VeryLazy",
  -- 可选:指定依赖
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
