local M = {}

-- Internal component functions
local function git_branch()
    local target_buf = vim.g.actual_curbuf or vim.api.nvim_get_current_buf()
    if not vim.wo.diff then return "" end

    local status, val = pcall(function() 
        return vim.api.nvim_buf_get_var(target_buf, "custom_git_branch") 
    end)

    return (status and val) and ("󰊢 " .. val) or ""
end

local function filename()
    local bufname = vim.api.nvim_buf_get_name(0)
    return bufname:match("DIFF_REF_") and "" or vim.fn.expand("%:t")
end

-- This function returns the table structure Lualine expects
M.get_sections = function()
    local gdiff_sections = {
        lualine_b = {
            { git_branch, color = { fg = '#e0af68', gui = 'bold' } },
            { 'branch', cond = function() return not vim.wo.diff end },
        },
        lualine_c = {
            { filename }
        }
    }
    return gdiff_sections
end

return M

