local conf = vim.g.config

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "onsails/lspkind-nvim" },
      { "folke/neoconf.nvim", config = true },
    },
    config = function()
      local lsp_settings = require("core.plugins.lsp.settings")
      local utils = require("core.plugins.lsp.utils")

      -- Setup capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
      local common_config = {
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        settings = {
          json = lsp_settings.json,
          Lua = lsp_settings.lua,
          gopls = lsp_settings.gopls,
          redhat = { telemetry = { enabled = false } },
          yaml = lsp_settings.yaml,
        },
      }

      for _, lsp in ipairs(conf.lsp_servers) do
        vim.lsp.config(lsp, common_config)
      end

      -- Enable all configured LSP servers
      vim.lsp.enable(conf.lsp_servers)

      -- Custom LSP servers (not from Mason)
      vim.lsp.config("sourcekit", {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      })
      vim.lsp.config("cds_lsp", {})
      vim.lsp.enable({ "sourcekit", "cds_lsp" })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP Actions",
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local buffer = args.buf

          require("core.plugins.lsp.keys").on_attach(client, buffer)

          -- Telescope-based keymaps
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = buffer, desc = "LSP: " .. desc })
          end
          local builtin = require("telescope.builtin")
          map("gd", builtin.lsp_definitions, "Goto Definition")
          map("gr", builtin.lsp_references, "Goto References")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")

          -- Document highlight
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("thecoldstone-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = buffer,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
          end

          -- Gopls semantic tokens workaround
          if client and client.name == "gopls" then
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              if semantic then
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end
        end,
      })

      -- LSP log level
      if conf.plugins.lsp.log == "on" then
        vim.lsp.set_log_level("debug")
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    cmd = "Mason",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:nvim-java/mason-registry",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = conf.lsp_servers,
        automatic_installation = true,
      })

      -- Ensure tools are installed
      local mr = require("mason-registry")
      local function install_ensured()
        for _, tool in ipairs(conf.tools) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(install_ensured)
      else
        install_ensured()
      end
    end,
  },
}
