return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	version = "1.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"folke/lazydev.nvim",
		"rafamadriz/friendly-snippets",
	},

	opts = {
		keymap = {
			-- set to 'none' to disable the 'default' preset
			preset = "enter",
		},
		sources = {
			default = { "lsp", "path", "snippets", "lazydev" },
			providers = {
				lsp = { score_offset = 110 },
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				snippets = { score_offset = 90 },
			},
		},
		snippets = { preset = "luasnip" },
	},
}
