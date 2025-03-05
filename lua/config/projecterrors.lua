-- https://artem.rocks/posts/workspace_diagnostics_nvim
local loaded_clients = {}

local function trigger_workspace_diagnostics(client, bufnr, workspace_files)
  if vim.tbl_contains(loaded_clients, client.id) then
    return
  end
  table.insert(loaded_clients, client.id)

  if not vim.tbl_get(client.server_capabilities, 'textDocumentSync', 'openClose') then
    return
  end

  for _, path in ipairs(workspace_files) do
    if path == vim.api.nvim_buf_get_name(bufnr) then
      goto continue
    end

    local filetype = vim.filetype.match({ filename = path })

    if not vim.tbl_contains(client.config.filetypes, filetype) then
      goto continue
    end

    local params = {
      textDocument = {
        uri = vim.uri_from_fname(path),
        version = 0,
        text = vim.fn.join(vim.fn.readfile(path), "\n"),
        languageId = filetype
      }
    }
    client.notify('textDocument/didOpen', params)

    ::continue::
  end
end

local workspace_files = vim.fn.split(vim.fn.system('git ls-files'), "\n")
-- convert paths to absolute
workspace_files = map(workspace_files, function(_, path) return vim.fn.fnamemodify(path, ":p") end)
