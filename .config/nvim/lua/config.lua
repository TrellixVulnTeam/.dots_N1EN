-- Call a 'dispatch' function according to the file type
-- E.g. blah.graphql calls 'graphql.sh' to dispatch
function tmux_dispatch_filetype()
  filename = vim.fn.expand('%:p')
  filetype = vim.bo.filetype
  tmux_send_line("~/.dots/bin/" .. filetype .. ".sh " .. filename)
end

function tmux_send_paragraph()
  cmd([[ noau normal! yip ]])
  text = get_register('"')
  lines = {}
  for s in text:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end

  for key, line in ipairs(lines) do
    tmux_send_line(line, false)
  end
end

-- TODO handle escaped quotes in markdown blocks
function tmux_send_markdown_code_block()
  language = ""
  this_line = vim.api.nvim_get_current_line()
  if this_line:match("^%s*`.*`%s*$") then
    capture = this_line:gsub("^%s*`(.*)`%s*$", "%1")
    tmux_send_line(capture, false)
    return
  end

  start_code_block_nr = -1
  end_code_block_nr = -1

  buf_handle = vim.api.nvim_get_current_buf()
  current_line_nr = vim.fn.line(".")
  last_line_nr = vim.fn.line("$")
  buf = vim.api.nvim_buf_get_lines(buf_handle, 0, -1, false)
  for i = current_line_nr,1,-1 do
    this_line = buf[i]
    if this_line:match("^%s*```.*$") then
      language = this_line:gsub("^%s*```%s*(.*)%s*$", "%1")
      start_code_block_nr = i + 1
      break
    end
  end

  for i = current_line_nr,last_line_nr,1 do
    this_line = buf[i]
    if this_line:match("^%s*```.*$") then
      end_code_block_nr = i - 1
      break
    end
  end

  if start_code_block_nr == -1 or end_code_block_nr == -1 then
    print("No markdown code block found.")
    return
  end

  for i=start_code_block_nr,end_code_block_nr,1 do
    line = buf[i]
    if line ~= "" then
      tmux_send_line(line, false, language)
    end
  end
end


function tmux_send_line(line, interpret, language)
  flags = ""
  if not interpret then
    flags = "-l"
  end

  line = escape_tmux_cmd(trim(line), language)

  formatted_cmd = [[tmux send-keys ]] .. flags .. [[ -t {next} -- "]] .. line .. [["]]
  enter_cmd = [[tmux send-keys -t {next} -- "Enter"]]

  vim.fn.system(formatted_cmd, "silent")
  vim.fn.system(enter_cmd)
end

function get_register(register)
  return vim.api.nvim_exec("echo getreg('" .. register .. "')", true)
end

function escape_tmux_cmd(s, language)
  -- Escape backslashes first
  s = s:gsub('\\', "\\\\")

  -- We send the string inside "", so escape "
  s = s:gsub('"', "\\\"")

  -- escape subshells so they don't get evaluated on the 'tmux send-keys ..'
  -- command, but instead when they actually reach our shell
  s = s:gsub('%$', "\\$")

  -- s = s:gsub('#', "\\#")
  if language ~= "bash" then
    s = s:gsub(';', "\\;")
  end
  -- s = s:gsub('%%', "\\%%")
  -- s = s:gsub('!', "\\!")
  return s
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))		
    else
      print(formatting .. v)
    end
  end
end

function window_active()
end

function window_inactive()
end


-- plugins

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lA', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lW', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lspconfig = require('lspconfig')

local gopls_caps = vim.lsp.protocol.make_client_capabilities()

lspconfig['gopls'].setup {
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = gopls_caps,
}

lspconfig['tsserver'].setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspRenameFile<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "go", ":TSLspImportAll<CR>", { silent = true })
    on_attach(client, bufnr)
  end,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
    virtual_text = false,
  }
)

local on_attach = function(client, bufnr)
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", ":LspDef<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gy", ":LspTypeDef<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", ":LspHover<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[a", ":LspDiagPrev<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]a", ":LspDiagNext<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "ga", ":LspCodeAction<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>", { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", { silent = true })
  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end
end

local null_ls = require("null-ls")
my_prettier = null_ls
null_ls.builtins.formatting.prettier.disabled_filetypes = { "markdown", "yaml" }
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.prettier
  },
  on_attach = on_attach
})

-- Symbols outline
vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = 'right',
    width = 25,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    -- These keymaps can be a string or a table for multiple keys
    keymaps = {
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview  = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
        File = {icon = "", hl = "TSURI"},
        Module = {icon = "", hl = "TSNamespace"},
        Namespace = {icon = "", hl = "TSNamespace"},
        Package = {icon = "", hl = "TSNamespace"},
        Class = {icon = "𝓒", hl = "TSType"},
        Method = {icon = "ƒ", hl = "TSMethod"},
        Property = {icon = "", hl = "TSMethod"},
        Field = {icon = "", hl = "TSField"},
        Constructor = {icon = "", hl = "TSConstructor"},
        Enum = {icon = "ℰ", hl = "TSType"},
        Interface = {icon = "ﰮ", hl = "TSType"},
        Function = {icon = "", hl = "TSFunction"},
        Variable = {icon = "", hl = "TSConstant"},
        Constant = {icon = "", hl = "TSConstant"},
        String = {icon = "𝓐", hl = "TSString"},
        Number = {icon = "#", hl = "TSNumber"},
        Boolean = {icon = "⊨", hl = "TSBoolean"},
        Array = {icon = "", hl = "TSConstant"},
        Object = {icon = "⦿", hl = "TSType"},
        Key = {icon = "🔐", hl = "TSType"},
        Null = {icon = "NULL", hl = "TSType"},
        EnumMember = {icon = "", hl = "TSField"},
        Struct = {icon = "𝓢", hl = "TSType"},
        Event = {icon = "🗲", hl = "TSType"},
        Operator = {icon = "+", hl = "TSOperator"},
        TypeParameter = {icon = "𝙏", hl = "TSParameter"}
    }
}

require('gitsigns').setup()

require('telescope').setup{
  defaults = {
  }
}
