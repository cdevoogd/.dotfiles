--[[
| Arg | Applicible Modes                 |
| --- | -------------------------------- |
| n   | normal                           |
| i   | insert                           |
| s   | select                           |
| x   | visual                           |
| c   | command-line                     |
| t   | terminal                         |
| v   | visual + select                  |
| !   | insert + command-line            |
| l   | insert + command-line + lang-arg |
| o   | operator-pending                 |

https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings-set
https://neovim.io/doc/user/lua.html#vim.keymap.set()
--]]

local function map(mode, key, cmd, opts, defaults)
   local merged_opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})
   -- vim.keymap.set has noremap enabled by default
   vim.keymap.set(mode, key, cmd, merged_opts)
end

local function nmap(key, cmd, opts)
   return map("n", key, cmd, opts)
end

local function imap(key, cmd, opts)
   return map("i", key, cmd, opts)
end

local function vmap(key, cmd, opts)
   return map("v", key, cmd, opts)
end

local function xmap(key, cmd, opts)
   return map("x", key, cmd, opts)
end

local function omap(key, cmd, opts)
   return map("o", key, cmd, opts)
end

-- Faster buffer navigation
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

-- Resize window using shift + arrow keys
nmap("<S-Up>", ":resize +2<CR>")
nmap("<S-Down>", ":resize -2<CR>")
nmap("<S-Left>", ":vertical resize -2<CR>")
nmap("<S-Right>", ":vertical resize +2<CR>")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- Make `n` and `N` always search forward and backwards regardless of if a seach was started with `/` or `?`
nmap("n", "'Nn'[v:searchforward]", { expr = true })
xmap("n", "'Nn'[v:searchforward]", { expr = true })
omap("n", "'Nn'[v:searchforward]", { expr = true })
nmap("N", "'nN'[v:searchforward]", { expr = true })
xmap("N", "'nN'[v:searchforward]", { expr = true })
omap("N", "'nN'[v:searchforward]", { expr = true })

-- Don't reset the cursor position after yanking
-- (set mark, yank, go back to mark)
vmap("y", "myy`y")
vmap("Y", "myY`y")

-- Shortcuts for copying to the system clipboard
nmap("<leader>y", '"+y', { desc = "copy to clipboard" })
vmap("<leader>y", '"+y', { desc = "copy to clipboard" })
nmap("<leader>Y", '"+yy', { desc = "copy line to clipboard" })

-- https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
-- Automatically reselect the last selection when using `<` and `>` to shift lines
xmap(">", ">gv")
xmap("<", "<gv")

-- Files
nmap("<leader>fe", "<cmd>Oil<cr>", { desc = "file explorer (oil) " })

-- Buffer
nmap("<leader>bd", function()
   require("mini.bufremove").delete(0, false)
end, { desc = "delete current buffer" })

-- g: git
-- ap("<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "view commits" })

-- s: search
-- nmap("<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "search in buffer" })

-- x: diagnostics & errors
nmap("<leader>xf", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "diagnostics float" })

-- code + LSP
-- I used to do this only when an LSP attached to a buffer, but whatever. If I press on of these
-- keys and an LSP isn't attached I'll just get an error which is better than the keymap not
-- existing and doing nothing when I'm expecting an LSP to be attached imho.
nmap("K", vim.lsp.buf.hover)
nmap("]d", vim.diagnostic.goto_next, { desc = " go to next diagnostics" })
nmap("[d", vim.diagnostic.goto_prev, { desc = " go to prev diagnostic" })

nmap("<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
nmap("<leader>cr", vim.lsp.buf.rename, { desc = "rename symbol" })
nmap("<leader>cS", vim.lsp.buf.signature_help, { desc = "signature help" })
imap("<A-s>", vim.lsp.buf.signature_help, { desc = "signature help" })
