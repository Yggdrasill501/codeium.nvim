local M = {}

if vim.g.loaded_codeium_log then
    return
end
vim.g.loaded_codeium_log = 1

if not M.logfile then
    M.logfile = vim.fn.expand(vim.g.codeium_log_file or vim.fn.tempname() .. '-codeium.log')
    local success, _ = pcall(vim.fn.writefile, {}, M.logfile)
end

function M.Logfile()
    return M.logfile
end

function M.Log(level, msg)
    local min_level = string.upper(vim.g.codeium_log_level or 'WARN')
    local levels = { 'ERROR', 'WARN', 'INFO', 'DEBUG', 'TRACE' }

    for _, level_name in ipairs(levels) do
        if level_name == string.upper(level) then
            local success, _ = pcall(function()
                if vim.fn.filereadable(M.logfile) == 1 then
                    vim.fn.writefile(vim.fn.split(msg, "\n", true), M.logfile, 'a')
                end
            end)
            break
        end
        if level_name == min_level then
            break
        end
    end
end

function M.Error(msg)
    M.Log('ERROR', msg)
end

function M.Warn(msg)
    M.Log('WARN', msg)
end

function M.Info(msg)
    M.Log('INFO', msg)
end

function M.Debug(msg)
    M.Log('DEBUG', msg)
end

function M.Trace(msg)
    M.Log('TRACE', msg)
end

function M.Exception()
    if vim.v.exception ~= '' then
        M.Error('Exception: ' .. vim.v.exception .. ' [' .. vim.v.throwpoint .. ']')
    end
end

return M