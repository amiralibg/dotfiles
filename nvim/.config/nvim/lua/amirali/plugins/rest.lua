return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<leader>rr", function() require("kulala").run() end, desc = "Run HTTP Request" },
    { "<leader>rp", function() require("kulala").copy() end, desc = "Copy as cURL Command" },
    { "<leader>rl", function() require("kulala").replay() end, desc = "Re-run Last Request" },
  },
  opts = {
    global_keymaps = false,
  },
}
