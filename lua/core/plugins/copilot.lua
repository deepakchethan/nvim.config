return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  enabled = false,
  dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      event = { "InsertEnter", "LspAttach" },
      config = function(_, opts)
        local function on_att(on_attach)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local buffer = args.buf
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              on_attach(client, buffer)
            end,
          })
        end
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
        -- attach cmp source whenever copilot attaches
        -- fixes lazy-loading issues with the copilot cmp source
        -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/copilot.lua#L61
        on_att(function(client)
          if client.name == "copilot" then
            copilot_cmp._on_insert_enter({})
          end
        end)
      end,
    },
  },
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = false,
        auto_trigger = false,
        auto_refresh = true,
        debounce = 75,
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          accept = "<C-a>",
          next = "<C-aa>",
          dismiss = "<C-x>",
        },
      },
    })
  end,
}
