return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = {
    config = {
      header = {
        "",
        "  ██╗  ██╗███████╗██╗   ██╗    ██████╗  ██████╗  ",
        "  ██║  ██║██╔════╝╚██╗ ██╔╝    ██╔══██╗██╔════╝  ",
        "  ███████║█████╗   ╚████╔╝     ██║  ██║██║       ",
        "  ██╔══██║██╔══╝    ╚██╔╝      ██║  ██║██║       ",
        "  ██║  ██║███████╗   ██║       ██████╔╝╚██████╗  ",
        "  ╚═╝  ╚═╝╚══════╝   ╚═╝       ╚═════╝  ╚═════╝  ",
        "",
      },
      shortcut = {
        {
          icon = " ",
          desc = "New",
          action = "ene | startinsert",
          key = "e",
        },
        {
          icon = "󰍉 ",
          desc = "Find",
          action = require("utils.functions").project_files(),
          key = "f",
        },
        {
          icon = "󰍉 ",
          desc = "Grep",
          action = "Telescope live_grep",
          key = "s",
        },
        {
          icon = "󰹈 ",
          desc = "Projects",
          action = "NeovimProjectDiscover",
          key = "p",
        },
        { icon = " ", desc = "Lazy", group = "Label", action = "Lazy check", key = "l" },
        { desc = "Quit", group = "Number", action = "q", key = "q" },
      },
      mru = { enable = false, limit = 5, icon = " ", label = "Recent files", cwd_only = true },
      project = {
        enable = false,
        limit = 5,
        icon = "󰹈 ",
        label = "Recent Projects",
        action = "Telescope find_files cwd=",
      },
      footer = {
        "",
        "",
        "Live Fast. Be Wild. Die Young. Have Fun.",
        "",
        "",
      },
    },
  },
  config = function(_, opts)
    require("utils.functions").dashboard_autocmd(":Dashboard")
    require("dashboard").setup(opts)
  end,
}
