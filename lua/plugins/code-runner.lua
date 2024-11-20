return {
  "hkupty/iron.nvim",
  config = function()
    local iron = require("iron.core")
    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          sh = {
            command = { "zsh" },
          },
          python = {
            command = { "/opt/miniconda3/envs/myenv/bin/python" }, -- 或者使用 { "ipython", "--no-autoindent" }
            format = require("iron.fts.common").bracketed_paste,
          },
        },
        repl_open_cmd = require("iron.view").right(40),
      },
      keymaps = {
        send_motion = "<space>sc",
        visual_send = "<space>rc",
        send_file = "<space>sf",
        send_line = "<space>rl",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })

    -- 添加额外的快捷键
    vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>", { desc = "Start REPL" })
    vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>", { desc = "Restart REPL" })
    vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
    vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
  end,
}
