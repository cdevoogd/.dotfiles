return {
   "saghen/blink.cmp",
   version = "*",
   opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      signature = { enabled = true },
      snippets = { preset = "mini_snippets" },
      sources = {
         default = { "lsp", "path", "snippets", "buffer" },
      },
   },
   opts_extend = { "sources.default" },
}
