return {
  "coffebar/neovim-project",
  opts = {
    projects = { -- define project roots
      "~/tps/*",
      "~/Git/OSS/*",
      "/Users/I506629/.local/state/nvim",
      "/Users/I506629/SAPDevelop/AN/src/git/AN/*",
    },
    picker = {
      type = "telescope", -- or "fzf-lua"
    },
    dashboard_mode = true,
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100,
  keys = {
    { "<leader>sp", "<cmd>NeovimProjectDiscover<cr>", desc = "Search projects" },
  },
}
