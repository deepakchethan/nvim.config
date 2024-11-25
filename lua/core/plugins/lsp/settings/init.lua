local M = {}

M.lua = require("core.plugins.lsp.settings.lua_ls")
M.gopls = require("core.plugins.lsp.settings.gopls")
M.json = require("core.plugins.lsp.settings.jsonls")
M.yaml = require("core.plugins.lsp.settings.yaml")

return M
