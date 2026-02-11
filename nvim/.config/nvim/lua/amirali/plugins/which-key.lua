return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    preset = "modern",
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Register key groups with descriptions
    wk.add({
      -- Main leader groups
      { "<leader>a", group = "Aerial (Outline)", icon = "" },
      { "<leader>b", group = "Buffer", icon = "" },
      { "<leader>c", group = "Code/Console", icon = "" },
      { "<leader>d", group = "Debug (DAP)", icon = "" },
      { "<leader>e", group = "Explorer", icon = "" },
      { "<leader>f", group = "Find (Telescope)", icon = "" },
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>h", group = "Git Hunks", icon = "" },
      { "<leader>l", group = "LSP/Lint", icon = "" },
      { "<leader>m", group = "Format", icon = "" },
      { "<leader>n", group = "NPM/Packages", icon = "󰏗" },
      { "<leader>r", group = "REST/Refactor", icon = "" },
      { "<leader>s", group = "Split/Search/Session", icon = "" },
      { "<leader>t", group = "Tab/Terminal/TypeScript", icon = "" },
      { "<leader>to", group = "TypeScript Organize", icon = "" },
      { "<leader>w", group = "Session (Workspace)", icon = "" },
      { "<leader>x", group = "Trouble/Diagnostics", icon = "" },

      -- LSP groups (when LSP is attached)
      { "g", group = "Go to" },
      { "]", group = "Next" },
      { "[", group = "Previous" },

      -- Specific keybindings
      { "<leader>nh", desc = "Clear search highlights" },
      { "<leader>+", desc = "Increment number" },
      { "<leader>-", desc = "Decrement number" },
      { "<leader>sv", desc = "Split window vertically" },
      { "<leader>sh", desc = "Split window horizontally" },
      { "<leader>se", desc = "Make splits equal size" },
      { "<leader>sx", desc = "Close current split" },
      { "<leader>sm", desc = "Toggle maximize split" },
      { "<leader>to", desc = "Open new tab" },
      { "<leader>tx", desc = "Close current tab" },
      { "<leader>tn", desc = "Go to next tab" },
      { "<leader>tp", desc = "Go to previous tab" },
      { "<leader>tf", desc = "Open current buffer in new tab" },
      { "<leader>bn", desc = "Next buffer" },
      { "<leader>bp", desc = "Previous buffer" },
      { "<leader>bb", desc = "Switch to last buffer" },
      { "<leader>bc", desc = "Close current buffer" },
      { "<leader>ss", desc = "Save file" },
      { "<leader>cl", desc = "Insert console.log", mode = { "n", "v" } },
      { "<leader>/", desc = "Toggle comment", mode = { "n", "v" } },
      { "<C-p>", desc = "Find files (VSCode style)" },
      { "<C-S-f>", desc = "Find in files (VSCode style)" },
      { "<C-\\>", desc = "Toggle Terminal", mode = { "n", "t" } },

      -- Debug (DAP) keys
      { "<leader>db", desc = "Toggle Breakpoint" },
      { "<leader>dB", desc = "Conditional Breakpoint" },
      { "<leader>dc", desc = "Continue/Start Debugging" },
      { "<leader>di", desc = "Step Into" },
      { "<leader>do", desc = "Step Over" },
      { "<leader>dO", desc = "Step Out" },
      { "<leader>dr", desc = "Toggle REPL" },
      { "<leader>dl", desc = "Run Last" },
      { "<leader>dt", desc = "Terminate" },
      { "<leader>du", desc = "Toggle Debug UI" },
      { "<leader>de", desc = "Eval Expression", mode = { "n", "v" } },

      -- Package.json keys
      { "<leader>ns", desc = "Show Package Info" },
      { "<leader>nc", desc = "Hide Package Info" },
      { "<leader>nt", desc = "Toggle Package Info" },
      { "<leader>nu", desc = "Update Package" },
      { "<leader>nd", desc = "Delete Package" },
      { "<leader>ni", desc = "Install Package" },
      { "<leader>np", desc = "Change Package Version" },

      -- REST keys
      { "<leader>rr", desc = "Run HTTP Request" },
      { "<leader>rp", desc = "Preview cURL Command" },
      { "<leader>rl", desc = "Re-run Last Request" },

      -- Terminal keys
      { "<leader>tf", desc = "Toggle Float Terminal" },
      { "<leader>th", desc = "Toggle Horizontal Terminal" },
      { "<leader>tv", desc = "Toggle Vertical Terminal" },
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>tn", desc = "Node REPL" },
      { "<leader>tp", desc = "Python REPL" },

      -- TypeScript Tools keys
      { "<leader>toi", desc = "Organize Imports" },
      { "<leader>tos", desc = "Sort Imports" },
      { "<leader>tou", desc = "Remove Unused Imports" },
      { "<leader>tof", desc = "Fix All" },
      { "<leader>toa", desc = "Add Missing Imports" },
      { "<leader>tog", desc = "Go to Source Definition" },
      { "<leader>tor", desc = "Rename File" },
      { "<leader>toh", desc = "File References" },

      -- Aerial keys
      { "<leader>a", desc = "Toggle Outline (Aerial)" },
      { "<leader>ao", desc = "Open Outline" },
      { "<leader>ac", desc = "Close Outline" },
      { "<leader>an", desc = "Next Symbol" },
      { "<leader>ap", desc = "Previous Symbol" },
      { "<leader>at", desc = "Toggle Outline Tree" },

      -- Telescope keys
      { "<leader>ff", desc = "Find files" },
      { "<leader>fr", desc = "Recent files" },
      { "<leader>fs", desc = "Live grep (search in cwd)" },
      { "<leader>fc", desc = "Search string under cursor" },
      { "<leader>ft", desc = "Find todos" },
      { "<leader>,", desc = "Show open buffers" },

      -- File Explorer keys
      { "<leader>ee", desc = "Toggle NvimTree" },
      { "<leader>ef", desc = "Toggle explorer on current file" },
      { "<leader>ec", desc = "Collapse explorer" },
      { "<leader>er", desc = "Refresh explorer" },
      { "-", desc = "Open Oil (parent directory)" },

      -- Git keys
      { "<leader>lg", desc = "Open Lazygit" },
      { "]h", desc = "Next hunk" },
      { "[h", desc = "Previous hunk" },
      { "<leader>hs", desc = "Stage hunk" },
      { "<leader>hr", desc = "Reset hunk" },
      { "<leader>hS", desc = "Stage buffer" },
      { "<leader>hR", desc = "Reset buffer" },
      { "<leader>hu", desc = "Undo stage hunk" },
      { "<leader>hp", desc = "Preview hunk" },
      { "<leader>hb", desc = "Blame line" },
      { "<leader>hB", desc = "Toggle line blame" },
      { "<leader>hd", desc = "Diff this" },
      { "<leader>hD", desc = "Diff this (cached)" },

      -- Search & Replace keys
      { "<leader>sr", desc = "Search and replace in project" },
      { "<leader>sf", desc = "Search and replace in file" },
      { "<leader>sw", desc = "Search current word" },
      { "<leader>sc", desc = "Search cursor word" },

      -- Diagnostics & Errors keys
      { "<leader>xx", desc = "Toggle Trouble list" },
      { "<leader>xw", desc = "Workspace diagnostics" },
      { "<leader>xd", desc = "Document diagnostics" },
      { "<leader>xq", desc = "Quickfix list" },
      { "<leader>xl", desc = "Location list" },
      { "<leader>xt", desc = "Todos in Trouble" },

      -- Todo Navigation keys
      { "]t", desc = "Next todo comment" },
      { "[t", desc = "Previous todo comment" },

      -- LSP keys (these will be available when LSP is attached)
      { "gR", desc = "Show LSP references" },
      { "gD", desc = "Go to declaration" },
      { "gd", desc = "Show LSP definitions" },
      { "gi", desc = "Show LSP implementations" },
      { "gt", desc = "Show LSP type definitions" },
      { "gy", desc = "Show definition in new tab" },
      { "<leader>ca", desc = "Code actions", mode = { "n", "v" } },
      { "<leader>rn", desc = "Smart rename" },
      { "<leader>D", desc = "Show buffer diagnostics" },
      { "<leader>d", desc = "Show line diagnostics" },
      { "[d", desc = "Previous diagnostic" },
      { "]d", desc = "Next diagnostic" },
      { "K", desc = "Hover documentation" },
      { "<leader>rs", desc = "Restart LSP" },

      -- Session keys
      { "<leader>wr", desc = "Restore session for cwd" },
      { "<leader>ws", desc = "Save session" },

      -- Format keys
      { "<leader>mp", desc = "Format file", mode = { "n", "v" } },
      { "<leader>l", desc = "Lint file" },
    })
  end,
}
