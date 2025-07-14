return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			restore_win_options = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
			},
			-- NOTE: 🔧 Don't update cwd
			use_default_keymaps = true,
			keymaps = {},
			-- NOTE: 👇 this is the important one
			update_cwd = false,
		})
		vim.keymap.set("n", "-", "<cmd>Oil<CR>")
	end,
	dependencies = { "echasnovski/mini.icons" },
	lazy = false,
}
