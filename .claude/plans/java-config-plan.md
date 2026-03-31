# Plan: Fix Java Configuration with nvim-java

## Problem
- Current `mfussenegger/nvim-jdtls` setup fails with "jdtls requires at least Java 21" error
- The jdtls Python wrapper script doesn't properly detect Java version
- `gd` (go to definition) not working for Java files

## Solution
Switch back to `nvim-java/nvim-java` with proper configuration:

1. nvim-java handles all jdtls setup internally
2. nvim-java requires its custom Mason registry for package versions
3. nvim-java must be set up BEFORE `lspconfig.jdtls.setup()`

## Changes Required

### 1. Update `lua/core/plugins/lsp.lua`
- Add nvim-java's Mason registry to mason.nvim setup
- Remove `jdtls` from mason-lspconfig handlers (nvim-java manages it)

```lua
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:nvim-java/mason-registry",
  },
})
```

### 2. Replace `lua/core/plugins/java.lua`
- Use nvim-java instead of nvim-jdtls
- Configure nvim-java with `jdk.auto_install = false` (we have Java 21)
- Set up jdtls via lspconfig AFTER java.setup()

```lua
return {
  "nvim-java/nvim-java",
  ft = "java",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("java").setup({
      jdk = { auto_install = false },
      verification = { invalid_mason_registry = false },
    })
    require("lspconfig").jdtls.setup({})
  end,
}
```

### 3. Update `lua/config/defaults/mason.lua`
- Remove `jdtls` from lsp_servers list (nvim-java manages it via its own registry)

## Key Points
- nvim-java's registry provides specific versions of jdtls, lombok-nightly, java-debug-adapter, java-test
- The registry must be added to mason.nvim BEFORE nvim-java loads
- `jdk.auto_install = false` prevents nvim-java from installing OpenJDK-17 (we have Java 21)
- `verification.invalid_mason_registry = false` prevents errors if registry order causes issues
