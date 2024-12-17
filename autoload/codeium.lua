local M = {}

M.hlgroup = 'CodeiumSuggestion'
M.request_nonce = 0
M.using_codeium_status = 0

if not vim.fn.has('nvim') then
    if vim.fn.empty(vim.fn.prop_type_get(M.hlgroup)) then
        vim.fn.prop_type_add(M.hlgroup, { highlight = M.hlgroup })
    end
end

M.default_codeium_enabled = {
    help = 0,
    gitcommit = 0,
    gitrebase = 0,
    ['.'] = 0
}

function M.Enabled()
    if not vim.g.codeium_enabled or not vim.b.codeium_enabled then
        return false
    end

    local codeium_filetypes = M.default_codeium_enabled
    vim.fn.extend(codeium_filetypes, vim.g.codeium_filetypes or {})

    local codeium_filetypes_disabled_by_default = vim.g.codeium_filetypes_disabled_by_default or vim.b.codeium_filetypes_disabled_by_default

    if not codeium_filetypes[vim.bo.filetype] then
        return not codeium_filetypes_disabled_by_default
    end

    return true
end

function M.CompletionText()
    local success, result = pcall(function() return M.completion_text end)
    return success and result or ''
end

function M.CompletionInserter(current_completion, insert_text)
    local default = vim.g.codeium_tab_fallback or (vim.fn.pumvisible() == 1 and "<C-N>" or "\t")

    if not vim.fn.mode():match('^[iR]') or not vim.b._codeium_completions then
        return default
    end

    if not current_completion then
        return default
    end

    local range = current_completion.range
    local suffix = current_completion.suffix or {}
    local suffix_text = suffix.text or ''
    local delta = suffix.deltaCursorOffset or 0
    local start_offset = range.startOffset or 0
    local end_offset = range.endOffset or 0

    local text = insert_text .. suffix_text
    if text == '' then
        return default
    end

    local delete_range = ''
    if end_offset - start_offset > 0 then
        local delete_bytes = end_offset - start_offset
        local delete_chars = vim.fn.strchars(vim.fn.strpart(vim.fn.getline('.'), 0, delete_bytes))
        delete_range = " \<Esc>\"_x0\"_d" .. delete_chars .. 'li'
    end

    M.completion_text = text

    if delta == 0 then
        -- Additional logic for inserting completion text
    end
end

function M.GetCurrentCompletionItem()
    if vim.b._codeium_completions and vim.b._codeium_completions.items and vim.b._codeium_completions.index < #vim.b._codeium_completions.items then
        return vim.b._codeium_completions.items[vim.b._codeium_completions.index]
    end
    return nil
end

function M.RenderCurrentCompletion()
    M.ClearCompletion()
    M.RedrawStatusLine()

    if not vim.fn.mode():match('^[iR]') then
        return
    end

    -- Additional logic for rendering current completion
end

function M.Clear(...)
    vim.b._codeium_status = 0
    M.RedrawStatusLine()
    if vim.g._codeium_timer then
        vim.fn.timer_stop(vim.g._codeium_timer)
        vim.g._codeium_timer = nil
    end
end

function M.LaunchChat(out, err, status)
    local metadata = require('codeium.server').RequestMetadata()
    local processes = vim.fn.json_decode(table.concat(out, ''))
    local chat_port = processes.chatClientPort
    local ws_port = processes.chatWebServerPort
    -- Additional logic for launching chat
end

return M