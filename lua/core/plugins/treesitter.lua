local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "RRethy/nvim-treesitter-endwise",
    "mfussenegger/nvim-ts-hint-textobject",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local conf = vim.g.config
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      ensure_installed = conf.treesitter_ensure_installed,
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          scope_incremental = false,
          node_incremental = "<cr>",
          node_decremental = "<bs>",
        },
      },
      endwise = {
        enable = true,
      },
      indent = { enable = true },
      autopairs = { enable = true },
    })

    -- Setup parser configs for cds
    ---@class ParserInfo
    ---@field parser_config ParserInfo
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.cds = {
      install_info = {
        url = "https://github.com/cap-js-community/tree-sitter-cds.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = "cds",
      used_by = { "cdl", "hdbcds" },
    }

    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.cds" },
      command = "set filetype=cds",
    })

    require("nvim-ts-autotag").setup()
  end,
}

return M
