return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "rust", "lua", "java", "json", "python", "gdscript", "gdshader", "godot_resource" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
