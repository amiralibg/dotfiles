return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		local transparent = true -- set to true if you would like to enable transparency

		require("tokyonight").setup({
			transparent = transparent,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
