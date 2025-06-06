return {
    { "Bekaboo/dropbar.nvim" },
    { "yorickpeterse/nvim-pqf", opts = {} },
    {
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    -- Some integrations are disabled by default, so they are being enabled here
                    blink_cmp = true,
                    mason = true,
                    mini = { enabled = true, indentscope_color = "" },
                    snacks = { enabled = true },
                    lsp_trouble = true,
                },
                -- Make borders between windows clearer
                custom_highlights = function(colors)
                    return { WinSeparator = { fg = colors.flamingo } }
                end,
            })
            vim.cmd("colorscheme catppuccin")
        end,
    },
}
