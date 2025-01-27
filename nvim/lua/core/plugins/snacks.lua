local M = {
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

-- Cache the result of `git rev-parse`
local is_inside_work_tree = {}

-- Show git files when in a repository, otherwise just show all files.
-- Ideally this should be moved to a custom picker, but I haven't figured out how to do that yet.
M.project_files = function()
   local cwd = vim.fn.getcwd()
   if is_inside_work_tree[cwd] == nil then
      vim.fn.system("git rev-parse --is-inside-work-tree")
      is_inside_work_tree[cwd] = vim.v.shell_error == 0
   end

   if is_inside_work_tree[cwd] then
      Snacks.picker.git_files({ untracked = true })
   else
      Snacks.picker.files()
   end
end

return M
