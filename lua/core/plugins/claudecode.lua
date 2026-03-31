return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    -- Normal mode mappings
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },

    -- Terminal mode mappings (work from inside Claude terminal)
    { "<leader>cc", "<cmd>ClaudeCode<cr>", mode = "t", desc = "Toggle Claude" },
    { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", mode = "t", desc = "Focus Claude" },
    { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", mode = "t", desc = "Add current buffer" },
    { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", mode = "t", desc = "Accept diff" },
    { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", mode = "t", desc = "Deny diff" },
    { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", mode = "t", desc = "Select model" },

    -- Quick escape from terminal mode
    { "<C-x>", [[<C-\><C-n>]], mode = "t", desc = "Exit terminal mode" },
  },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  opts = {
    -- Server configuration
    auto_start = true,
    port_range = { min = 10000, max = 65535 },

    -- Behavior
    track_selection = true,
    focus_after_send = true,

    -- Terminal configuration
    terminal = {
      provider = "snacks",          -- Use snacks.nvim for terminal management
      split_side = "right",
      split_width_percentage = 0.4, -- 40% width (value between 0 and 1)
      git_repo_cwd = true,          -- Use git root as working directory
    },

    -- Diff configuration
    diff_opts = {
      layout = "horizontal",       -- Top/bottom diff view
      open_in_new_tab = true,      -- Open diffs in a new tab (keeps main workspace clean)
      keep_terminal_focus = false, -- Focus the diff, not the terminal
      hide_terminal_in_new_tab = false, -- Show Claude terminal in diff tab for reference
    },

    -- Claude CLI configuration
    -- Uncomment and adjust if using local installation
    -- terminal_cmd = vim.fn.expand("~/.claude/local/claude"),
  },
  config = function(_, opts)
    require("claudecode").setup(opts)
  end,
}
