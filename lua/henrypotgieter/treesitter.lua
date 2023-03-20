local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "php", "javascript", "python", "bash", "c", "lua", "vim", "help", "json", "yaml", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,


  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  autopairs ={
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}

require("nvim-treesitter.configs").setup {
  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    disable = { "jsx", "cpp" },
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require 'ts-rainbow'.strategy.global,
  }
}
