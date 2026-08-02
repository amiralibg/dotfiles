require("amirali.core")

-- ponytail: skip the whole plugin/UI layer under vscode-neovim; VSCode owns the UI.
-- Want surround/Comment/autopairs in VSCode too? add a small whitelisted plugins module.
if not vim.g.vscode then
	require("amirali.lazy")
end
