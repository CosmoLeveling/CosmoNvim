local M = { "L3MON4D3/LuaSnip" }
M.dependencies = { "rafamadriz/friendly-snippets" }
M.version = "v2.*"
M.build = function()
	if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
		return
	end
	return "make install_jsregexp"
end
function M.config()
	require("luasnip").setup({ enable_autosnippets = true })
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_lua").load({
		paths = { "./snippets" },
	})
end

return M
