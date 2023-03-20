local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("henrypotgieter.lsp.mason")
require("henrypotgieter.lsp.handlers").setup()
require("henrypotgieter.lsp.null-ls")
