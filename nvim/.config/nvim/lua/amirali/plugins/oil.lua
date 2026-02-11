return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = function()
		require("oil").setup({
			columns = { "icon" },
			show_hidden = true,
			keymaps = {
				["<C-h>"] = "false",
				["<M-h>"] = "actions.select_split",
			},
		})

		-- Open parent directory
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

		-- Open parent directory in floating window
		vim.keymap.set(
			"n",
			"<space>-",
			require("oil").toggle_float,
			{ desc = "Open parent directory in floating window" }
		)
	end,
}
