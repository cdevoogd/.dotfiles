vim.g.mapleader = " "

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
]]
--

-- Note: By default vim.keymap.set() behaves likes :noremap uses nonrecursive remaps
local map = function(mode, key, cmd, opts, defaults)
   opts = vim.tbl_deep_extend("force", defaults or {}, opts or {})
   vim.keymap.set(mode, key, cmd, opts)
end

local nmap = function(key, cmd, opts) map("n", key, cmd, opts, {}) end
local xmap = function(key, cmd, opts) map("x", key, cmd, opts, {}) end
local omap = function(key, cmd, opts) map("o", key, cmd, opts, {}) end

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

-- https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
-- Automatically reselect the last selection when using `<` and `>` to shift lines
xmap(">", ">gv")
xmap("<", "<gv")

nmap("<leader>`", "<cmd>:e #<cr>", { desc = "switch to last buffer" })
nmap("<leader>bs", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "switch buffer" })
nmap("<leader>bd", "<cmd>Bdelete<CR>", { desc = "delete buffer" })

-- f: files
nmap("<leader>fe", "<cmd>Oil<cr>", { desc = "open file explorer" })
nmap("<leader>ff", "<cmd>Oil --float<cr>", { desc = "open floating file explorer" })
nmap("<leader>fn", "<cmd>enew<cr>", { desc = "new file" })

-- g: git
nmap("<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "view commits" })
nmap("<leader>gC", "<cmd>Telescope git_bcommits<CR>", { desc = "view buffer commits" })
nmap("<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "view branches" })
nmap("<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "view status" })
nmap("<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "view stashes" })

-- s: search
nmap("<leader>sr", "<cmd>Telescope resume<cr>", { desc = "resume search" })
nmap("<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "search files" })
nmap("<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "search all files (grep)" })
nmap("<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "search recent files" })
nmap("<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "search in buffer" })
nmap(
   "<leader>ss",
   function()
      require("telescope.builtin").lsp_document_symbols({
         symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait" },
      })
   end,
   { desc = "search lsp symbols" }
)
nmap("<leader>sh", "<cmd>Telescope command_history<cr>", { desc = "search command history" })
nmap("<leader>sm", "<cmd>Telescope marks<cr>", { desc = "search marks" })
nmap("<leader>sc", "<cmd>Telescope commands<cr>", { desc = "search commands" })
nmap("<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "search help pages" })
nmap("<leader>sm", "<cmd>Telescope man_pages<cr>", { desc = "search man pages" })
nmap("<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "search keymaps" })
nmap("<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "search vim options" })
nmap("<leader>su", "<cmd>Telescope undo<cr>", { desc = "search undo tree" })

-- x: diagnostics & errors
nmap("<leader>xf", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "diagnostics float" })
nmap("<leader>xt", "<cmd>Telescope diagnostics<cr>", { desc = "telescope diagnostics" })

-- t: toggle
local util = require("util")
nmap("<leader>tn", function() util.toggle("number") end, { desc = "toggle line numbers" })
nmap("<leader>tr", function() util.toggle("relativenumber") end, { desc = "toggle relative line numbers" })
nmap("<leader>ts", function() util.toggle("spell") end, { desc = "toggle spell checking" })
nmap("<leader>tw", function() util.toggle("wrap") end, { desc = "toggle word wrap" })
nmap("<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "toggle floating terminal" })

-- Remap escape to the combo needed to help exit the ToggleTerm
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])

-- code + LSP
-- I used to do this only when an LSP attached to a buffer, but whatever. If I press on of these
-- keys and an LSP isn't attached I'll just get an error which is better than the keymap not
-- existing and doing nothing when I'm expecting an LSP to be attached imho.
nmap("K", vim.lsp.buf.hover)
nmap("]d", vim.diagnostic.goto_next, { desc = " go to next diagnostics" })
nmap("[d", vim.diagnostic.goto_prev, { desc = " go to prev diagnostic" })

nmap("<leader>cgd", "<cmd>Telescope lsp_definitions<cr>", { desc = "go to definitions" })
nmap("<leader>cgD", "<cmd>Telescope lsp_declarations<cr>", { desc = "go to declaration" })
nmap("<leader>cgt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "go to type definition" })
nmap("<leader>cgr", "<cmd>Telescope lsp_references<cr>", { desc = "go to references" })
nmap("<leader>cgi", "<cmd>Telescope lsp_implementations<cr>", { desc = "go to implementations" })

nmap("<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
nmap("<leader>cr", vim.lsp.buf.rename, { desc = "rename symbol" })
nmap("<leader>cs", vim.lsp.buf.signature_help, { desc = "signature help" })
