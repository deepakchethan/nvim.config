return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>cc", mode = { "n", "t" }, desc = "Toggle Claude Code" },
    { "<leader>cC", mode = "n", desc = "Continue Claude conversation" },
    { "<leader>cr", mode = "n", desc = "Resume Claude conversation" },
    { "<leader>cv", mode = "n", desc = "Claude Code verbose" },
  },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeContinue",
    "ClaudeCodeResume",
    "ClaudeCodeVerbose",
  },
  config = function()
    require("claude-code").setup({
      -- Window configuration
      split_ratio = 0.4, -- 40% of editor width (for right split)
      position = "botright vsplit", -- Open as vertical split on the right
      enter_insert = true, -- Auto-enter insert mode when opening
      start_in_normal_mode = false, -- Start in normal mode instead
      hide_numbers = true, -- Hide line numbers in terminal
      hide_signcolumn = true, -- Hide sign column in terminal

      -- Float window options
      float = {
        width = 0.9,
        height = 0.9,
        row = 0.05,
        col = 0.05,
        border = "rounded",
        relative = "editor",
      },

      -- File refresh settings
      file_refresh = {
        enable = true, -- Enable automatic file refresh
        updatetime = 100, -- Update time in milliseconds
        timer_interval = 1000, -- Check interval in milliseconds
        show_notifications = false, -- Show reload notifications
      },

      -- Git integration
      use_git_root = true, -- Automatically detect and use git root
      multi_instance = false, -- Allow multiple instances per git repo

      -- Shell configuration
      shell = {
        separator = "&&", -- Command separator
        pushd_cmd = "pushd", -- Push directory command
        popd_cmd = "popd", -- Pop directory command
      },

      -- Keymaps
      keymaps = {
        -- Toggle Claude Code terminal
        toggle = {
          normal = "<leader>cc",      -- Toggle in normal mode
          terminal = "<leader>cc",    -- Toggle in terminal mode
          variants = {
            continue = "<leader>cC",  -- Continue conversation
            resume = "<leader>cr",    -- Resume conversation
            verbose = "<leader>cv",   -- Verbose mode
          },
        },
        -- Enable window navigation shortcuts (Ctrl-h/j/k/l)
        window_navigation = true,
        -- Enable scrolling shortcuts (Ctrl-f/b)
        scrolling = true,
      },

      -- Command configuration
      command = "claude", -- Claude Code binary name
      command_variants = {
        continue = "--continue",
        resume = "--resume",
        verbose = "--verbose",
      },

      -- which-key integration is handled in which-key.lua config
    })

    -- Terminal mode mappings for Claude Code
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("ClaudeCodeTerminal", { clear = true }),
      pattern = "*claude*",
      callback = function()
        local opts = { buffer = 0, noremap = true, silent = true }

        -- Terminal escape mappings
        local escape_keys = {
          { "t", "<Esc>", [[<C-\><C-n>]] },
          { "t", "<C-[>", [[<C-\><C-n>]] },
          { "t", "jk", [[<C-\><C-n>]] },
        }

        -- Window navigation from terminal
        local nav_keys = {
          { "t", "<C-h>", [[<C-\><C-n><C-w>h]] },
          { "t", "<C-j>", [[<C-\><C-n><C-w>j]] },
          { "t", "<C-k>", [[<C-\><C-n><C-w>k]] },
          { "t", "<C-l>", [[<C-\><C-n><C-w>l]] },
        }

        for _, map in ipairs(escape_keys) do
          vim.keymap.set(map[1], map[2], map[3], opts)
        end
        for _, map in ipairs(nav_keys) do
          vim.keymap.set(map[1], map[2], map[3], opts)
        end
      end,
      desc = "Claude Code terminal keymaps",
    })

    -- Optional: Add custom commands for common workflows
    vim.api.nvim_create_user_command("ClaudeAsk", function(opts)
      -- Open Claude Code and immediately send a prompt
      vim.cmd("ClaudeCode " .. opts.args)
    end, {
      desc = "Ask Claude Code a question",
      nargs = "+",
    })

    -- Optional: Integration with your existing config
    -- Automatically reload buffers when Claude modifies them
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("ClaudeCodeReload", { clear = true }),
      callback = function()
        -- Trigger file watcher check after buffer write
        -- This ensures changes are properly synchronized
        vim.cmd("checktime")
      end,
      desc = "Check for external file changes after save",
    })
  end,
}
