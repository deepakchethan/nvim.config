# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration written in Lua, using lazy.nvim as the plugin manager. The configuration is inspired by LunarVim and follows a modular, extensible architecture with support for multiple programming languages (Go, Python, Java, Lua, JavaScript/TypeScript, Terraform, YAML, Markdown, and more).

## Architecture

### Configuration Loading System

The configuration uses a two-tier loading system:

1. **Default Configuration** (`lua/config/defaults/`): Core defaults for options, plugins, LSP servers, formatters, linters, theme, and treesitter
2. **User Configuration** (`~/.nvim_config.lua`): Optional user overrides that merge with defaults via `utils.merge_tables()`

The initialization flow:
- `init.lua` → `lua/config/init.lua` → loads defaults → merges user config → applies options → loads autocmds → initializes lazy.nvim → loads mappings

### Directory Structure

- `lua/config/`: Core configuration (defaults, lazy.nvim setup, mappings, autocmds)
- `lua/core/plugins/`: Individual plugin configurations (each plugin in its own file)
- `lua/core/plugins/lsp/`: LSP-specific configuration (keys, settings per LSP, utilities)
- `lua/utils/`: Utility functions, globals, icons
- `after/ftplugin/`: Filetype-specific settings
- `snippets/`: Custom snippets per language
- `queries/`: Custom treesitter queries

### Plugin Management

Uses lazy.nvim with plugins loaded from `lua/core/plugins/`. Each plugin is typically in its own file returning a lazy.nvim spec table.

Key settings:
- Lockfile: `lazy-lock.json` (in repo root)
- Dev path: `$HOME/workspace/github.com/` for local plugin development
- Change detection: disabled by default

## Language-Specific Setup

### LSP Configuration

LSP servers are configured in two places:
1. **Server list**: `lua/config/defaults/mason.lua` - lists servers to auto-install
2. **Server settings**: `lua/core/plugins/lsp/settings/` - per-language settings (gopls, lua_ls, jsonls, yaml)

LSP setup happens in:
- `lua/core/plugins/lsp.lua` - mason integration and LspAttach autocmd
- `lua/core/plugins/lsp/lsp.lua` - individual server setup with capabilities

Custom LSP servers (not from Mason):
- `sourcekit` - for CDS/Swift
- `cds_lsp` - for SAP CDS

### Java

Java requires special handling via nvim-java plugin:
- Configuration in `lua/core/plugins/java.lua`
- Filetype plugin: `after/ftplugin/java.lua`
- JDTLS is installed via Mason but configured by nvim-java

### Formatters and Linters

- **Formatters**: Configure via `conform.nvim` in `lua/config/defaults/conform.lua`
  - Format on save is enabled by default (toggle with `<leader>tF`)
  - Per-language formatters defined in `formatters_by_ft`

- **Linters**: Configure via `nvim-lint` in `lua/config/defaults/lint.lua`
  - Currently disabled by default (`enable = false`)
  - Per-language linters defined in `linters_by_ft`

## Common Commands

### Development

- Open Lazy plugin manager: `<space>ml`
- Open Mason: `:Mason`
- Reload snippets: `<space>ms`
- Toggle autoformat: `<space>tF`
- Toggle linting: `<space>tL`

### Claude Code Integration

- Toggle Claude terminal: `<leader>cc`
- Focus Claude terminal: `<leader>cf`
- Send visual selection to Claude: `<leader>cs` (visual mode)
- Add current buffer to Claude context: `<leader>cb`
- Accept Claude diff: `<leader>ca`
- Deny Claude diff: `<leader>cd`
- Select Claude model: `<leader>cm`

### Testing Changes

When testing configuration changes:
1. Source the file: `:source %` or restart Neovim
2. Check for errors: `:checkhealth`
3. Use minimal configs for debugging: `minimal_init_lazy.lua` or `minimal_init_packer.lua`

### Diagnostics

- Run health check: `:checkhealth` (custom health check in `lua/core/health.lua`)
- Check LSP status: `:LspInfo`
- Check LSP logs: `vim.lsp.set_log_level("debug")` is controlled by `vim.g.config.plugins.lsp.log`

## Key Design Patterns

### Safe Config Access

Use `utils.safe_nested_config(config, ...)` to safely access nested config values without nil errors.

### Plugin Enablement

Many plugins can be disabled via config:
```lua
vim.g.config.plugins.<plugin_name>.enable = false
```

### LSP On Attach

LSP keybindings and setup use `utils.on_attach()` function. Core bindings:
- `gd` - Go to definition (Telescope)
- `gr` - Go to references (Telescope)
- `gD` - Go to declaration

### User Configuration

Users can create `~/.nvim_config.lua` to override defaults:
```lua
return {
  lsp_servers = { "lua_ls", "gopls" }, -- override LSP servers
  plugins = {
    conform = { disable_autoformat = true },
    noice = { enable = false },
  },
}
```

## Special Files

- `lazy-lock.json` - Plugin version lockfile (committed to repo)
- `.neoconf.json` - Neoconf settings for Lua development
- `selene.toml` - Selene linter configuration
- `vim.toml` - Additional Vim configuration

## Custom Utilities

- `utils.functions.project_files()` - Smart file finder (git-aware)
- `utils.functions.file_browser()` - Smart file browser (yazi/lf/telescope)
- `utils.functions.toggle_qf()` - Toggle quickfix list
- `utils.functions.escapePair()` - Move over closing brackets in insert mode

## Autocmds

Key automatic behaviors (see `lua/config/autocmds.lua`):
- Trim trailing whitespace on save
- Terraform filetype detection (`.tf` → `terraform`)
- Typst filetype detection (`.typ` → `typst`)
- Spell checking enabled for `.txt`, `.md`, `.tex`, `.typ` files
- Close certain windows with `q` key
- Highlight on yank
- Restore cursor position when opening buffers

## Claude Code Integration

This configuration uses claudecode.nvim (https://github.com/coder/claudecode.nvim) for Claude Code CLI integration:

- **Terminal Provider**: Uses snacks.nvim for terminal management
- **Split Position**: Opens as a vertical split on the right (40% width)
- **Git Awareness**: Automatically uses git root as working directory
- **Real-time Context**: Tracks visual selections for quick context sharing
- **Diff Management**: Built-in commands to accept/deny Claude's proposed changes

Configuration file: `lua/core/plugins/claudecode.lua`

Key commands:
- `:ClaudeCode` - Toggle Claude terminal window
- `:ClaudeCodeFocus` - Smart focus/toggle Claude terminal
- `:ClaudeCodeSelectModel` - Choose model and open terminal
- `:ClaudeCodeSend` - Send visual selection to Claude
- `:ClaudeCodeAdd <file>` - Add file to Claude's context
- `:ClaudeCodeDiffAccept` - Accept proposed changes
- `:ClaudeCodeDiffDeny` - Reject proposed changes

### Requirements

- Neovim ≥ 0.8.0
- Claude Code CLI installed (`claude doctor` to verify)
- folke/snacks.nvim dependency (included in plugin dependencies)

