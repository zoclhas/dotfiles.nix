local lspconfig = require("lspconfig")

lspconfig.qmlls.setup({
  cmd = { "qmlls", "-E" },
  filetypes = { "qml" },
  root_markers = { ".qmlls.ini", "shell.qml", ".git" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qml",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

return {}
