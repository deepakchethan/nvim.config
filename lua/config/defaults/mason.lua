-- Tools that should be installed by Mason
-- LSPs that should be installed by Mason-lspconfig
return {
  lsp_servers = {
    "bashls",
    "dockerls",
    "jsonls",
    "gopls",
    "helm_ls",
    "ltex",
    "marksman",
    "pyright",
    "lua_ls",
    "terraformls",
    "texlab",
    "ts_ls",
    "yamlls",
    "jdtls",
  },

  tools = {
    -- Formatter
    "isort",
    "prettier",
    "stylua",
    "shfmt",
    -- Linter
    "hadolint",
    "eslint_d",
    "shellcheck",
    "selene",
    "tflint",
    "yamllint",
    "ruff",
    -- DAP
    "debugpy",
    "delve",
    "codelldb",
    -- Go
    "gofumpt",
    "goimports",
    "gomodifytags",
    "golangci-lint",
    "gotests",
    "iferr",
    "impl",
  },
}
