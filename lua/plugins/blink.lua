return { -- Autocompletion
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	config = function()
		require("blink-cmp").setup()
		vim.keymap.set("i", "<Tab>", function()
			local cmp = require("blink.cmp")
			if cmp.is_visible() then
				cmp.select_next()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
			end
		end, { noremap = true, silent = true })
		vim.keymap.set("i", "<CR>", function()
			local cmp = require("blink.cmp")
			if cmp.is_visible() and cmp.get_selected_item then
				cmp.accept()
			else
				print("running else")
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
			end
		end, { noremap = true, silent = true })
	end,

	dependencies = {
		"L3MON4D3/LuaSnip",
		"folke/lazydev.nvim",
	},
	opts = {
		keymap = {
			preset = "default",
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = { auto_show = false },
		},

		snippets = {
			preset = "luasnip",
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = { enabled = true },
	},
}
