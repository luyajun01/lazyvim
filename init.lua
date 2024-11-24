-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- configure python3_host_prog
vim.g.python3_host_prog = "/opt/miniconda3/envs/myenv/bin/python"

-- init.lua
-- 设置文件编码
vim.opt.fileencoding = "utf-8"
vim.opt.encoding = "utf-8"

-- 确保已经设置好字体
vim.o.guifont = "JetBrains\\ Mono:h14"
vim.o.guifontwide = "TsangerJinKai03\\ W03:h14"

-- 启用特定的渲染选项
vim.opt.termguicolors = true

-- 为 markdown 文件特别设置
-- init.lua
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.md",
  callback = function()
    vim.o.guifontwide = "TsangerJinKai03\\ W03:h14"
  end,
})

_G.pynappo = {}
local o = vim.o
local g = vim.g
local opt = vim.opt

o.cmdheight = 1
o.showtabline = 2
o.laststatus = 3

-- Line numbers
o.signcolumn = "auto:2"
o.relativenumber = true
o.number = true

-- Enable mouse
o.mouse = "a"
o.mousescroll = "ver:8,hor:6"
o.mousemoveevent = true

-- Tabs
o.tabstop = 2
o.vartabstop = "2"
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- More intuitive splits
o.splitright = true
o.splitbelow = true

-- Line breaks
o.linebreak = true
o.breakindent = true
o.wrap = false
o.clipboard = "unnamed"

-- Pop up menu stuff
o.pumblend = 0
o.updatetime = 500
opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }
vim.fn.setreg("b", "ihi")

-- Misc.
o.confirm = true
o.showmode = false
o.history = 1000
o.scrolloff = 4
o.undofile = true
o.smoothscroll = true
opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "globals",
  "terminal",
  "options",
}
opt.wildoptions:append("fuzzy")
opt.diffopt = {
  "internal",
  "filler",
  "vertical",
  "linematch:60",
}

-- UI stuff
o.cursorline = true
opt.whichwrap:append("<,>,h,l,[,]")
opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
  eob = " ",
  fold = " ",
  diff = "╱",
}
o.list = true
opt.listchars = {
  extends = "⟩",
  precedes = "⟨",
  trail = "·",
  tab = "╏ ",
  nbsp = "␣",
}
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})
o.termguicolors = true

g.mapleader = " "
g.maplocalleader = "\\"

vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    source = "if_many",
  },
  virtual_lines = { only_current_line = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  float = {
    border = "single",
    format = function(d)
      return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
    end,
  },
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- GUI stuff
o.guifont = "Inconsolata Nerd Font Mono,TsangerJinKai03:h18:#e-subpixelantialias"
--vim.opt.guifontwide = "TsangerJinKai03:h14:#e-subpixelantialias" -- 专门设置中文字体
--o.guifont = "TsangerJinKai03:h12:#e-subpixelantialias"
if g.neovide then
  g.neovide_transparency = 1.0
  -- macOS 专属：窗口模糊效果
  g.neovide_window_blurred = true
  -- macOS 专属：Option 键作为 Meta 键
  g.neovide_input_macos_option_key_is_meta = "only_left"
  g.neovide_refresh_rate = 144
  g.neovide_cursor_vfx_mode = "ripple"
  g.neovide_cursor_animation_length = 0.13
  g.neovide_cursor_trail_size = 0.8
  g.neovide_remember_window_size = true
  -- 光标粒子效果（可选：railgun, torpedo, pixiedust, sonicboom, ripple, wireframe）
  g.neovide_cursor_vfx_mode = "pixiedust"
  g.neovide_scroll_animation_length = 0.3
  -- 浮动窗口的阴影（美化）
  g.neovide_floating_shadow = true
  g.neovide_floating_z_height = 10
  g.neovide_light_angle_degrees = 45
  g.neovide_light_radius = 5
  g.neovide_confirm_quit = true
  g.neovide_refresh_rate_idle = 5
end

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])

vim.paste = (function(overridden)
  return function(lines, phase)
    for i, line in ipairs(lines) do
      -- Scrub ANSI color codes from paste input.
      lines[i] = line:gsub("\27%[[0-9;mK]+", "")
    end
    overridden(lines, phase)
  end
end)(vim.paste)

-- IME 输入法切换优化
local function set_ime(args)
  if args.event:match("Enter$") then
    vim.g.neovide_input_ime = true
  else
    vim.g.neovide_input_ime = false
  end
end

local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = ime_input,
  pattern = "*",
  callback = set_ime,
})

-- init.lua
