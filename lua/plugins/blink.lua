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
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {},
			opts = {},
			config = function()
				local ls = require("luasnip")
				local s = ls.snippet
				local t = ls.text_node
				local i = ls.insert_node
				ls.add_snippets("gdscript", {
					-- @export var name: Type
					s("exp", {
						t("@export var "),
						i(1, "name"),
						t(": "),
						i(2, "int"),
					}),

					-- signal
					s("sig", {
						t("signal "),
						i(1, "my_signal"),
					}),

					-- enum Name { A, B, C }
					s("enu", {
						t("enum "),
						i(1, "MyEnum"),
						t(" { "),
						i(2, "A, B, C"),
						t(" }"),
					}),

					-- const NAME = VALUE
					s("const", {
						t("const "),
						i(1, "NAME"),
						t(" = "),
						i(2, "value"),
					}),

					-- extends Node
					s("ext", {
						t("extends "),
						i(1, "Node"),
					}),

					-- class_name MyClass
					s("cls", {
						t("class_name "),
						i(1, "MyClass"),
					}),

					-- @onready var name = $Node
					s("ready", {
						t("@onready var "),
						i(1, "my_var"),
						t(" = $"),
						i(2, "Node"),
					}),
				})
			end,
		},
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

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = { enabled = true },
	},
}
