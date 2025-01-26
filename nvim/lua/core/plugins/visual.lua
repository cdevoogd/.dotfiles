return {
   "catppuccin/nvim",
   config = function()
      require("catppuccin").setup({
         flavour = "mocha",
         integrations = {
            -- Some integrations are disabled by default, so they are being enabled here
            mason = true,
            mini = {
               enabled = true,
               indentscope_color = "",
            },
         },
      })
      vim.cmd("colorscheme catppuccin")
   end,
}
