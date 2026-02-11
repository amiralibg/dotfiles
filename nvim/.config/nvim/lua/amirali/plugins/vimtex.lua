return {
	"lervag/vimtex",
	lazy = false, -- Keep this false for VimTeX
	-- tag = "v2.15", -- Optional: pin to a specific release
	init = function()
		-- Configuration settings that need to be set BEFORE VimTeX loads
		vim.g.vimtex_view_method = "skim"

		-- REMOVE THIS LINE:
		-- vim.g.vimtex_compiler_method = "xelatex" -- INCORRECT

		-- ADD THIS BLOCK to configure latexmk:
		vim.g.vimtex_compiler_latexmk = {
			-- Tell latexmk to use xelatex as the engine
			program = "xelatex",

			-- You can add other latexmk options here if needed, e.g.:
			-- options = {
			--    '-file-line-error',
			--    '-interaction=nonstopmode'
			-- },
		}

		-- Optional Skim settings
		vim.g.vimtex_view_skim_sync = 1
		vim.g.vimtex_view_skim_activate = 1
	end,
	-- Use 'keys' for simple mappings or 'config' for more complex setup
	keys = {
		-- Define your keymaps here. These are common examples.
		-- Use <leader> which is typically '\' by default
		-- Compile
		{ "<leader>ll", "<Plug>(vimtex-compile)", desc = "VimTeX Compile" },
		{
			"<leader>l L",
			"<Plug>(vimtex-compile-selected)",
			mode = "v", -- Visual mode mapping
			desc = "VimTeX Compile Selected",
		},
		{ "<leader>lc", "<Plug>(vimtex-clean)", desc = "VimTeX Clean" },
		{ "<leader>lC", "<Plug>(vimtex-clean-full)", desc = "VimTeX Clean Full" },
		{ "<leader>lg", "<Plug>(vimtex-status)", desc = "VimTeX Status" },
		{ "<leader>lG", "<Plug>(vimtex-status-all)", desc = "VimTeX Status All" },

		-- View
		{ "<leader>lv", "<Plug>(vimtex-view)", desc = "VimTeX View" },

		-- Navigation & Info
		{ "<leader>li", "<Plug>(vimtex-info)", desc = "VimTeX Info" },
		{ "<leader>lt", "<Plug>(vimtex-toc-open)", desc = "VimTeX TOC Open" },
		{ "<leader>lT", "<Plug>(vimtex-toc-toggle)", desc = "VimTeX TOC Toggle" },
		{ "<leader>ls", "<Plug>(vimtex-imaps-list)", desc = "VimTeX Imaps List" },

		-- Errors
		{ "[q", "<Plug>(vimtex-qf-prev)", desc = "VimTeX Prev Error" },
		{ "]q", "<Plug>(vimtex-qf-next)", desc = "VimTeX Next Error" },

		-- You can add more mappings based on :help vimtex-mappings
	},
	-- Alternatively, use a config function for more complex setup or if
	-- you prefer setting keymaps using vim.keymap.set directly.
	-- config = function()
	--  vim.keymap.set("n", "<leader>ll", "<Plug>(vimtex-compile)", { desc = "VimTeX Compile" })
	--  -- Add other mappings here
	-- end,
}
