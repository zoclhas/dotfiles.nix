vim.lsp.config("qmlls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/qmlls", "-E" },
  filetypes = { "qml" },
  root_markers = { ".qmlls.ini", "shell.qml", ".git" },
})
vim.lsp.enable("qmlls")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qml",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

return {}
