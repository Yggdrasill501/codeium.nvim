local M = {}

if vim.g.loaded_codeium then
    return
end
vim.g.loaded_codeium = 1

-- Command to enable Codeium
vim.api.nvim_create_user_command('CodeiumEnable', function()
    M.Enable()
end, { nargs = 0 })

-- Command to disable Codeium
vim.api.nvim_create_user_command('CodeiumDisable', function()
    M.Disable()
end, { nargs = 0 })

-- Command to toggle Codeium
vim.api.nvim_create_user_command('CodeiumToggle', function()
    M.Toggle()
end, { nargs = 0 })

-- Command to set manual completion mode
vim.api.nvim_create_user_command('CodeiumManual', function()
    M.Manual()
end, { nargs = 0 })

-- Command to set automatic completion mode
vim.api.nvim_create_user_command('CodeiumAuto', function()
    M.Auto()
end, { nargs = 0 })

-- Command to initiate chat
vim.api.nvim_create_user_command('CodeiumChat', function()
    M.Chat()
end, { nargs = 0 })

function M.Enable()
    vim.g.codeium_enabled = true
    -- Additional logic to start the language server
end

function M.Disable()
    vim.g.codeium_enabled = false
end

function M.Toggle()
    if vim.g.codeium_enabled then
        M.Disable()
    else
        M.Enable()
    end
end

function M.Manual()
    vim.g.codeium_manual = true
end

function M.Auto()
    vim.g.codeium_manual = false
end

function M.Chat()
    -- Logic to initiate chat
end

-- Menu bindings for Codeium commands
vim.cmd [[
    amenu Plugin.Codeium.Enable\ \Codeium\ \(\:CodeiumEnable\) :call M.Enable() <Esc>
    amenu Plugin.Codeium.Disable\ \Codeium\ \(\:CodeiumDisable\) :call M.Disable() <Esc>
    amenu Plugin.Codeium.Toggle\ \Codeium\ \(\:CodeiumToggle\) :call M.Toggle() <Esc>
    amenu Plugin.Codeium.Manual\ \Codeium\ \AI\ \Autocompletion\ \(\:CodeiumManual\) :call M.Manual() <Esc>
    amenu Plugin.Codeium.Automatic\ \Codeium\ \AI\ \Completion\ \(\:CodeiumAuto\) :call M.Auto() <Esc>
    amenu Plugin.Codeium.Chat\ \Codeium\ \(\:CodeiumChat\) :call M.Chat() <Esc>
]]

return M