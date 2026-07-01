local M = {}

function M.open_default_branch()
    local cmd = vim.system({ "git", "symbolic-ref", "refs/remotes/origin/HEAD" }, { text = true }):wait()
    if cmd.code ~= 0 then
        require("utils").error("Failed to execute git to determine the default branch")
        return nil
    end

    local parts = vim.split(cmd.stdout, "/")
    local def_branch_name = string.gsub(parts[4], "%s+", "")
    local line_start, line_end = M.get_range()
    Snacks.gitbrowse({
        what = "permalink",
        branch = def_branch_name,
        line_start = line_start,
        line_end = line_end,
    })
end

function M.open_current_branch()
    local cmd = vim.system({ "git", "rev-parse", "HEAD" }, { text = true }):wait()
    if cmd.code ~= 0 then
        require("utils").error("Failed to execute git to determine the latest commit")
        return nil
    end

    local last_commit = string.gsub(cmd.stdout, "%s+", "")
    local line_start, line_end = M.get_range()
    Snacks.gitbrowse({
        what = "permalink",
        commit = last_commit,
        line_start = line_start,
        line_end = line_end,
    })
end

function M.get_range()
    local cursor_line = vim.fn.line(".")
    local visual_end_line = vim.fn.line("v")
    local range_start = math.min(cursor_line, visual_end_line)
    local range_end = math.max(cursor_line, visual_end_line)
    return range_start, range_end
end

function M.load_qflist_with_conflicts()
    local files = vim.fn.systemlist("git diff --name-only --diff-filter=U 2>/dev/null")
    if vim.v.shell_error ~= 0 or #files == 0 then
        print("No merge conflicts found")
        return
    end

    local items = {}
    for _, f in ipairs(files) do
        local abs = vim.fn.fnamemodify(f, ":p")
        for _, line in ipairs(vim.fn.systemlist("grep -n '^<<<<<<< ' " .. vim.fn.shellescape(f))) do
            local lnum = tonumber(line:match("^(%d+):"))
            local text = line:match("^%d+:(.*)")
            table.insert(items, { filename = abs, lnum = lnum, text = text })
        end
    end
    vim.fn.setqflist({}, " ", { items = items, title = "Conflicts" })
    vim.cmd("copen")
end

return M
