local M = {}

local function get_git_branches(arg_lead)
    local branches = vim.fn.systemlist("git branch --all --format='%(refname:short)'")
    local seen = {}
    local result = {}
    for _, branch in ipairs(branches) do
        local clean_name = branch:gsub("^origin/", "")
        if not seen[clean_name] and clean_name:match("^" .. arg_lead) then
            table.insert(result, clean_name)
            seen[clean_name] = true
        end
    end
    return result
end

M.git_diff_split = function(branch)
    local original_ft = vim.bo.filetype
    local original_buf = vim.api.nvim_get_current_buf()
    local file_path = vim.fn.expand("%")
    if file_path == "" then return end

    branch = (branch and branch ~= "") and branch or "master"
    local current_branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1] or "working"

    vim.api.nvim_buf_set_var(original_buf, "custom_git_branch", current_branch)
    vim.opt.splitright = true
    vim.cmd("vnew")
    
    local scratch_buf = vim.api.nvim_get_current_buf()
    local cmd = string.format("git show %s:%s", branch, file_path)
    local content = vim.fn.systemlist(cmd)
    
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_buf_delete(scratch_buf, { force = true })
        print("Branch not found: " .. branch)
        return
    end

    vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, content)
    vim.api.nvim_buf_set_var(scratch_buf, "custom_git_branch", branch)
    
    vim.bo[scratch_buf].filetype = original_ft
    vim.bo[scratch_buf].buftype = "nofile"
    vim.bo[scratch_buf].bufhidden = "wipe"
    vim.bo[scratch_buf].modifiable = false
    vim.api.nvim_buf_set_name(scratch_buf, "DIFF_REF_" .. branch)

    vim.wo.number = false
    vim.wo.signcolumn = "no"

    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
    
    vim.cmd("redraw!")
    vim.api.nvim_echo({}, false, {})
end

M.close_git_diff = function()
    vim.cmd("diffoff!")
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match("DIFF_REF_") then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
    vim.cmd("redraw!")
    vim.api.nvim_echo({}, false, {})
end

M.setup = function()
    vim.api.nvim_create_user_command("Gdiff", function(opts) 
        M.git_diff_split(opts.args) 
    end, { 
        nargs = "?", 
        complete = get_git_branches 
    })
    
    vim.keymap.set("n", "<leader>dc", M.close_git_diff, { desc = "Close Git Diff" })
end

return M

