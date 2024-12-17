local M = {}

-- Function to get line ending characters
function M.LineEndingChars()
    return "\n"
end

-- Function to check if the current version supports virtual text
function M.HasSupportedVersion()
    local nvim_virt_text_support = vim.fn.has('nvim-0.6') == 1 and vim.fn.exists('*nvim_buf_get_mark') == 1
    local vim_virt_text_support = vim.fn.has('patch-9.0.0185') == 1 and vim.fn.has('textprop') == 1

    return nvim_virt_text_support or vim_virt_text_support
end

-- Function to check if remote chat is being used
function M.IsUsingRemoteChat()
    local chat_ports = vim.g.codeium_port_config or {}
    return chat_ports.chat_client ~= nil and chat_ports.chat_client ~= '' and chat_ports.web_server ~= nil and chat_ports.web_server ~= ''
end

return M