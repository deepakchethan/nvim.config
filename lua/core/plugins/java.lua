return {
    'nvim-java/nvim-java',
    ft = "java",
    config = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        opts = {
          servers = {
            jdtls = {
              -- Your custom jdtls settings goes here
            },
          },
          setup = {
            jdtls = function()
              require('java').setup({
                -- Your custom nvim-java configuration goes here
              })
            end,
          },
        },
      },
    },
  }