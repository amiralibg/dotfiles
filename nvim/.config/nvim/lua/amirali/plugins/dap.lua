return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mxsdev/nvim-dap-vscode-js",
  },
  keys = {
    { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
    { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Conditional Breakpoint" },
    { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue/Start Debugging" },
    { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
    { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
    { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
    { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
    { "<leader>dl", "<cmd>DapRunLast<cr>", desc = "Run Last" },
    { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
    { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle Debug UI" },
    { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "Eval Expression", mode = { "n", "v" } },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup dapui
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25,
          position = "bottom",
        },
      },
    })

    -- Setup virtual text
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
    })

    -- Auto open/close dapui
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Setup adapters for JS/TS
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
      debugger_cmd = { "js-debug-adapter" },
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    -- JS/TS configurations
    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }
    end

    -- Signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "🔵", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
  end,
}
