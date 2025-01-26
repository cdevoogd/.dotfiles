return {
   "folke/snacks.nvim",
   priority = 1000,
   lazy = false,
   opts = {
      bigfile = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      indent = {
         enabled = true,
         -- https://github.com/folke/snacks.nvim/discussions/332
         indent = { enabled = false },
      },
      picker = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
   },
}
