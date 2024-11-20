--opts = {
--  provider = "gemini",
--  behaviour = {
--    auto_suggestions = false,
--    auto_set_highlight_group = true,
--    auto_set_keymaps = true,
--    auto_apply_diff_after_generation = false,
--    support_paste_from_clipboard = false,
--  },
--  gemini = {
--    model = "gemini-1.5-pro-exp-0827",
--    temperature = 0,
--    max_tokens = 4096,
-- },
--},
-- return {}
-- avante.nvim is a Neovim plugin designed to emulate the behaviour of the
-- Cursor AI IDE. It provides users with AI-driven code suggestions and the
-- ability to apply these recommendations directly to their source files
-- with minimal effort.
-- https://github.com/yetone/avante.nvim

return {
  -- code companion
  {
    "mrjones2014/legendary.nvim",
    opts = {
      extensions = {
        codecompanion = true,
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          agent = {
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.5-sonnet",
                },
              },
            })
          end,
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "AIzaSyABqQq6a9zbnuE_oyLxd5_Uc1UuolqFgQY",
              },
            })
          end,
        },
        prompt_library = {
          ["Docstring"] = {
            strategy = "inline",
            description = "Generate docstring for this function",
            opts = {
              modes = { "v" },
              short_name = "docstring",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false,
            },
            prompts = {
              {
                role = "system",
                content = function(context)
                  return "I want you to act as a senior "
                    .. context.filetype
                    .. " developer. I will send you a function and I want you to generate the docstrings for the function using the numpy format. Generate only the docstrings and nothing more. Put the generated docstring at the correct position in the code. Use tabs instead of spaces"
                end,
              },
              {
                role = "user",
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return text
                end,
                opts = {
                  visible = false,
                  placement = "add",
                  contains_code = true,
                },
              },
            },
          },
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  -- {
  --   "stevearc/conform.nvim",
  --   -- event = 'BufWritePre', -- uncomment for format on save
  --   opts = require("configs.conform"),
  -- },
  --
  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("configs.lspconfig")
  --   end,
  -- },
  --
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  -- },
  --
  -- {
  --   "mg979/vim-visual-multi",
  --   branch = "master",
  --   event = "VeryLazy",
  -- },
  --
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "copilot",
      -- provider = "gemini",
      auto_suggestions_provider = "copilot",
      -- auto_suggestions_provider = "gemini",
      copilot = {
        model = "claude-3.5-sonnet",
        -- model = "o1-mini",
        proxy = "http://127.0.0.1:6152",
      },
      -- gemini = {
      --   model = "gemini-1.5-pro-exp-0827",
      --   temperature = 0,
      --   max_tokens = 4096,
      --   proxy = "http://127.0.0.1:6152",
      -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({})
        end,
      },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
