return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  opts = {
    on_attach = function(client, bufnr)
      -- Disable formatting (use Prettier via conform.nvim instead)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      expose_as_code_action = "all",
      tsserver_path = nil,
      tsserver_plugins = {},
      tsserver_max_memory = "auto",
      tsserver_format_options = {},
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      tsserver_locale = "en",
      complete_function_calls = false,
      include_completions_with_insert_text = true,
      code_lens = "off",
      disable_member_code_lens = true,
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  },
  keys = {
    { "<leader>toi", "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize Imports" },
    { "<leader>tos", "<cmd>TSToolsSortImports<cr>", desc = "Sort Imports" },
    { "<leader>tou", "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "Remove Unused Imports" },
    { "<leader>tof", "<cmd>TSToolsFixAll<cr>", desc = "Fix All" },
    { "<leader>toa", "<cmd>TSToolsAddMissingImports<cr>", desc = "Add Missing Imports" },
    { "<leader>tog", "<cmd>TSToolsGoToSourceDefinition<cr>", desc = "Go to Source Definition" },
    { "<leader>tor", "<cmd>TSToolsRenameFile<cr>", desc = "Rename File" },
    { "<leader>toh", "<cmd>TSToolsFileReferences<cr>", desc = "File References" },
  },
}
