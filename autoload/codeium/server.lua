local M = {}

M.language_server_version = '1.20.8'
M.language_server_sha = '37f12b83df389802b7d4e293b3e1a986aca289c0'
M.root = vim.fn.expand('<sfile>:h:h:h')
M.bin = nil

if vim.fn.has('nvim') == 1 then
    M.ide = 'neovim'
else
    M.ide = 'vim'
end

if not vim.g.editor_version then
    if vim.fn.has('nvim') == 1 then
        M.ide_version = vim.fn.matchstr(vim.fn.execute('version'), 'NVIM v\\zs[^[:space:]]+')
    else
        local major = math.floor(vim.version / 100)
        local minor = vim.version % 100
        if vim.fn.exists('v:versionlong') then
            local patch = string.format('%04d', vim.versionlong % 1000)
            M.ide_version = string.format('%d.%d.%s', major, minor, patch)
        else
            M.ide_version = string.format('%d.%d', major, minor)
        end
    end
end

M.server_port = nil
if require('codeium.util').IsUsingRemoteChat() then
    M.server_port = 42100
end

vim.g.codeium_server_job = nil

function M.OnExit(result, status, on_complete_cb)
    if result.closed then
        result.closed = nil
        on_complete_cb(result.out, result.err, status)
    else
        result.exit_status = status
    end
end

function M.OnClose(result, on_complete_cb)
    if result.exit_status then
        on_complete_cb(result.out, result.err, result.exit_status)
    else
        result.closed = true
    end
end

function M.NoopCallback(...)
end

function M.RequestMetadata()
    return {
        api_key = require('codeium.command').ApiKey(),
        ide_name = M.ide,
        ide_version = M.ide_version,
        extension_name = 'vim',
        extension_version = M.language_server_version,
    }
end

function M.Request(type, data, ...)
    if M.server_port == nil then
        error('Server port has not been properly initialized.')
    end
    local uri = 'http://127.0.0.1:' .. M.server_port .. '/exa.language_server_pb.LanguageServerService/' .. type
    local json_data = vim.fn.json_encode(data)
    local args = {
        'curl', uri,
        '--header', 'Content-Type: application/json',
        '-d@-'
    }
    local result = { out = {}, err = {} }
    local ExitCallback = select('#', ...) > 0 and select(1, ...) or M.NoopCallback
    -- Execute the curl command here (implementation needed)
end

function M.Start(...)
    local user_defined_codeium_bin = vim.g.codeium_bin or ''
    if user_defined_codeium_bin ~= '' and vim.fn.filereadable(user_defined_codeium_bin) then
        M.bin = user_defined_codeium_bin
    end
    -- Additional logic for starting the server (implementation needed)
end

return M