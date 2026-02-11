return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "BufRead package.json",
  config = function()
    require("package-info").setup({
      colors = {
        up_to_date = "#3C4048",
        outdated = "#d19a66",
      },
      icons = {
        enable = true,
        style = {
          up_to_date = "|  ",
          outdated = "|  ",
        },
      },
      autostart = true,
      hide_up_to_date = false,
      hide_unstable_versions = false,
    })
  end,
  keys = {
    { "<leader>ns", "<cmd>lua require('package-info').show()<cr>", desc = "Show Package Info" },
    { "<leader>nc", "<cmd>lua require('package-info').hide()<cr>", desc = "Hide Package Info" },
    { "<leader>nt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle Package Info" },
    { "<leader>nu", "<cmd>lua require('package-info').update()<cr>", desc = "Update Package" },
    { "<leader>nd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete Package" },
    { "<leader>ni", "<cmd>lua require('package-info').install()<cr>", desc = "Install Package" },
    { "<leader>np", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change Package Version" },
  },
}
