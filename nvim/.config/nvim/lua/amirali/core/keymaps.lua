vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- commented out tab commands
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- buffer commands
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to last buffer" })
keymap.set("n", "<leader>bc", "<cmd>bd<CR>", { desc = "Close current buffer" })

-- save file
keymap.set("n", "<leader>ss", "<cmd>w<CR>", { desc = "Save file" }) -- save file

-- next line without insert mode
keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

-- VSCode-like keymaps
keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files (VSCode style)" })
keymap.set("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Find in files (VSCode style)" })
keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- [[ console.log with variable name ]]
keymap.set("n", "<leader>cl", function()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    local line = string.format('console.log("%s:", %s);', word, word)
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { line })
    vim.cmd("normal! j")
  else
    local line = 'console.log("");'
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { line })
    vim.cmd("normal! j^f\"a")
  end
end, { desc = "Insert console.log" })

-- console.log for visual selection
keymap.set("v", "<leader>cl", function()
  vim.cmd('normal! "vy')
  local selection = vim.fn.getreg("v")
  local line = string.format('console.log("%s:", %s);', selection, selection)
  vim.cmd("normal! '>")
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { line })
  vim.cmd("normal! j")
end, { desc = "Console.log selection" })
