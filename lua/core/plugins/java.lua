return {
  "nvim-java/nvim-java",
  ft = "java",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- Ensure JAVA_HOME is set for jdtls wrapper
    vim.env.JAVA_HOME = "/Library/Java/JavaVirtualMachines/sapmachine-21.jdk/Contents/Home"

    require("java").setup({
      jdk = { auto_install = false },
      notifications = { dap = false },
    })

    vim.lsp.enable("jdtls")
  end,
  keys = {
    { "<leader>Jo", "<cmd>lua require('java').runner.built_in.run_app()<cr>", desc = "Run Java App", ft = "java" },
    { "<leader>Js", "<cmd>lua require('java').runner.built_in.stop_app()<cr>", desc = "Stop Java App", ft = "java" },
    { "<leader>Jt", "<cmd>JavaTestRunCurrentMethod<cr>", desc = "Test Method", ft = "java" },
    { "<leader>JT", "<cmd>JavaTestRunCurrentClass<cr>", desc = "Test Class", ft = "java" },
    { "<leader>Jp", "<cmd>JavaProfile<cr>", desc = "Run Profile", ft = "java" },
    { "<leader>Jb", "<cmd>JavaBuildBuildWorkspace<cr>", desc = "Build Workspace", ft = "java" },
    { "<leader>Jc", "<cmd>JavaBuildCleanWorkspace<cr>", desc = "Clean Workspace", ft = "java" },
  },
}
