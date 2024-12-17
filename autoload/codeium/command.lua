local M = {}

-- Function to get the browser command based on the operating system
function M.BrowserCommand()
    if vim.fn.has('win32') == 1 and vim.fn.executable('rundll32') == 1 then
        return 'rundll32 url.dll,FileProtocolHandler'
    elseif vim.fn.isdirectory('/private') == 1 and vim.fn.executable('/usr/bin/open') == 1 then
        return '/usr/bin/open'
    end
    return ''
end

-- Function to get the home directory for Codeium
function M.HomeDir()
    local data_dir = os.getenv('XDG_DATA_HOME')
    if data_dir == nil or data_dir == '' then
        data_dir = os.getenv('HOME') .. '/.codeium'
    else
        data_dir = data_dir .. '/.codeium'
    end
    return data_dir
end

-- Function to load configuration from a specified directory
function M.LoadConfig(dir)
    local config_path = dir .. '/config.json'
    if vim.fn.filereadable(config_path) == 1 then
        local contents = vim.fn.readfile(config_path)
        if #contents > 0 then
            return vim.fn.json_decode(table.concat(contents, ''))
        end
    end
    return {}
end

-- Function to start the language server
function M.StartLanguageServer()
    if not vim.g.codeium_server_started then
        vim.fn.timer_start(0, function() require('codeium.server').Start() end)
        vim.g.codeium_server_started = true
    end
end

-- Function to authenticate
function M.Auth(...)
    if not require('codeium.util').HasSupportedVersion() then
        local min_version
        if vim.fn.has('nvim') == 1 then
            min_version = 'NeoVim 0.6'
        else
            min_version = 'Vim 9.0.0185'
        end
        vim.api.nvim_err_writeln('This version of Vim is unsupported. Install ' .. min_version .. ' or greater to use Codeium.')
        return
    end

    local config = vim.g.codeium_server_config or {}
    local portal_url = config.portal_url or 'https://www.codeium.com'
    local url = portal_url .. '/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query'
    local browser = M.BrowserCommand()
    local opened_browser = false

    if browser ~= '' then
        vim.api.nvim_echo({{'Navigating to ' .. url, 'None'}}, false, {})
        local result = os.execute(browser .. ' "' .. url .. '"')
        if result == 0 then
            opened_browser = true
        end

        if not opened_browser then
            vim.api.nvim_echo({{'Failed to open browser. Please go to the link above.', 'None'}}, false, {})
        end
    else
        vim.api.nvim_echo({{'No available browser found. Please go to ' .. url, 'None'}}, false, {})
    end
end

return M