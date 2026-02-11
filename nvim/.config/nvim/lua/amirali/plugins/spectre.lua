return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("spectre").setup({
			live_update = true,
		})
	end,
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").open()
			end,
			desc = "Spectre: Search and Replace in Project",
		},

		{
			"<leader>sf",
			function()
				require("spectre").open_file_search()
			end,
			desc = "Spectre: Search and Replace in File",
		},

		{
			"<leader>sw",
			function()
				require("spectre").open_visual()
			end,
			desc = "Spectre: Search Current Word",
		},

		{
			"<leader>sc",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Spectre: Search Cursor Word",
		},
	},
}
