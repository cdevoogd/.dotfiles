local show_detailed_columns = false
local undetailed_columns = {}
local detailed_columns = { "permissions", "size" }
return {
   "stevearc/oil.nvim",
   lazy = false,
   opts = {
      delete_to_trash = true,
      columns = undetailed_columns,
      lsp_file_methods = {
         autosave_changes = true,
      },
      keymaps = {
         ["q"] = "actions.close",
         ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
               show_detailed_columns = not show_detailed_columns
               if show_detailed_columns then
                  require("oil").set_columns(detailed_columns)
               else
                  require("oil").set_columns(undetailed_columns)
               end
            end,
         },
      },
   },
}
