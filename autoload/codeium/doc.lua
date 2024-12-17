local M = {}

-- Language enumeration
M.language_enum = {
    unspecified = 0,
    c = 1,
    clojure = 2,
    coffeescript = 3,
    cpp = 4,
    csharp = 5,
    css = 6,
    cudacpp = 7,
    dockerfile = 8,
    go = 9,
    groovy = 10,
    handlebars = 11,
    haskell = 12,
    hcl = 13,
    html = 14,
    ini = 15,
    java = 16,
    javascript = 17,
    json = 18,
    julia = 19,
    kotlin = 20,
    latex = 21,
    tex = 21,
    less = 22,
    lua = 23,
    makefile = 24,
    markdown = 25,
    objectivec = 26,
    objectivecpp = 27,
    perl = 28,
    php = 29,
    plaintext = 30,
    protobuf = 31,
    pbtxt = 32,
    python = 33,
    r = 34,
    ruby = 35,
    rust = 36,
    sass = 37,
    scala = 38,
    scss = 39,
    shell = 40,
    sql = 41,
    starlark = 42,
    swift = 43,
    typescriptreact = 44,
    typescript = 45,
    visualbasic = 46,
    vue = 47,
    xml = 48,
    xsl = 49,
    yaml = 50,
    svelte = 51,
    toml = 52,
    dart = 53,
    rst = 54,
    ocaml = 55,
    cmake = 56,
    pascal = 57,
    elixir = 58,
    fsharp = 59,
    lisp = 60,
    matlab = 61,
    ps1 = 62,
    solidity = 63,
    ada = 64,
    blade = 84,
    astro = 85,
}

M.filetype_aliases = {
    bash = 'shell',
    coffee = 'coffeescript',
    cs = 'csharp',
    cuda = 'cudacpp',
    dosini = 'ini',
    javascriptreact = 'javascript',
    make = 'makefile',
    objc = 'objectivec',
    objcpp = 'objectivecpp',
    proto = 'protobuf',
    raku = 'perl',
    sh = 'shell',
    text = 'plaintext',
}

-- Function to get document details
function M.GetDocument(bufId, curLine, curCol)
    local lines = vim.fn.getbufline(bufId, 1, '$')
    if vim.fn.getbufvar(bufId, '&endofline') then
        table.insert(lines, '')
    end

    local filetype = vim.fn.substitute(vim.fn.getbufvar(bufId, '&filetype'), '\\..*', '', '')
    local language = M.filetype_aliases[filetype] or (filetype == '' and 'text' or filetype)
    
    if filetype == '' and vim.g.codeium_warn_filetype_missing ~= false then
        require('codeium.log').Warn('No filetype detected. This will affect completion quality.')
        vim.g.codeium_warn_filetype_missing = false
    end

    local editor_language = filetype == '' and 'unspecified' or vim.fn.getbufvar(bufId, '&filetype')
    local doc = {
        text = table.concat(lines, require('codeium.util').LineEndingChars()),
        editor_language = editor_language,
        language = M.language_enum[language] or 0,
        cursor_position = { row = curLine - 1, col = curCol - 1 },
        absolute_path_migrate_me_to_uri = vim.fn.fnamemodify(vim.fn.bufname(bufId), ':p'),
    }

    local line_ending = require('codeium.util').LineEndingChars(nil)
    if line_ending ~= nil then
        doc.line_ending = line_ending
    end

    return doc
end

-- Function to get editor options
function M.GetEditorOptions()
    return {
        tab_size = vim.bo.shiftwidth,
        insert_spaces = vim.bo.expandtab and true or false,
    }
end

return M