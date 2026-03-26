return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  keys = {
    {
      "<leader>aM",
      function()
        local config = require("avante.config")
        local current_mode = config.mode
        local new_mode = current_mode == "agentic" and "legacy" or "agentic"
        config.override({ mode = new_mode })
        vim.notify("Avante mode: " .. new_mode, vim.log.levels.INFO)
      end,
      desc = "Toggle Avante mode (agentic/legacy)",
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  opts = function()
    local utils = require("utils.functions")
    local settings_path = utils.get_home() .. utils.path_separator() .. ".claude" .. utils.path_separator() .. "settings.json"

    local env = {}
    local ok, content = pcall(vim.fn.readfile, settings_path)
    if ok then
      local claude_settings = vim.json.decode(table.concat(content, "\n")) or {}
      env = claude_settings.env or {}
    end

    if env.ANTHROPIC_AUTH_TOKEN then
      vim.env.ANTHROPIC_AUTH_TOKEN = env.ANTHROPIC_AUTH_TOKEN
    end

    return {
      provider = "claude",
      mode = "legacy",
      providers = {
        claude = {
          endpoint = env.ANTHROPIC_BASE_URL or "https://api.anthropic.com",
          model = env.ANTHROPIC_DEFAULT_SONNET_MODEL or "claude-sonnet-4-20250514",
          timeout = 30000,
          api_key_name = "ANTHROPIC_AUTH_TOKEN",
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        auto_approve_tool_permissions = false,
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        cancel = {
          normal = { "<C-c>", "q" },
          insert = { "<C-c>" },
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          retry = "r",
          edit = "e",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = { "<Esc>", "q" },
        },
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        focus = "<leader>af",
        stop = "<leader>aS",
        toggle = {
          default = "<leader>at",
          debug = "<leader>ad",
          hint = "<leader>ah",
          suggestion = "<leader>as",
          repomap = "<leader>aR",
        },
        files = {
          add_current = "<leader>ac",
          add_all = "<leader>aB",
        },
        select_model = "<leader>a?",
        select_history = "<leader>aH",
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours",
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      },
    }
  end,
}
