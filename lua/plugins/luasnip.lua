return {

  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    build = function()
      if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then return end
      return 'make install_jsregexp'
    end,

    opts = {
      enable_autosnippets = true,
    },

    config = function(_, opts)
      require('luasnip').setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_lua').load({
        paths = { './snippets' },
      })
    end,
  },
}
