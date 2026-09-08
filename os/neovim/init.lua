-- keybinds
vim.g.mapleader = " "
vim.opt.wrap = false
vim.keymap.set("n", "<C-w>", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end)

-- diagnostics
do
	local ERROR = vim.diagnostic.severity.ERROR
	local WARN = vim.diagnostic.severity.WARN
	local config = vim.diagnostic.config

	local reset = function()
		config({
			signs = false,
			underline = false,
			jump = { severity = {} },
		})
	end
	reset()
	vim.keymap.set("n", "<leader>e", function()
		config({
			underline = { severity = ERROR },
			jump = { severity = ERROR },
			float = { severity = ERROR }
		})
	end)
	vim.keymap.set("n", "<leader>w", function()
		config({
			underline = { severity = WARN },
			jump = { severity = WARN },
			float = { severity = WARN }
		})
	end)
	vim.keymap.set("n", "<leader>d", function()
		config({
			underline = true,
			float = true,
			jump = {},
		})
	end)
	vim.keymap.set("n", "<leader>r", reset)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float)
end

-- telescope
require("telescope").setup {
	extensions = {
		file_browser = {
			hijack_netrw = true
		}
	}
}
require("telescope").load_extension "file_browser"
vim.keymap.set("n", "<C-e>", function()
	require("telescope").extensions.file_browser.file_browser()
end)

-- schedule sync of OS clipboard (it can be slow)
vim.api.nvim_create_autocmd('UIEnter', {
	callback = function()
		vim.o.clipboard = 'unnamedplus'
	end,
})

-- undotree
vim.keymap.set('n', '<leader>u', function()
	vim.cmd.UndotreeToggle()
	vim.cmd.UndotreeFocus()
end)
vim.opt.undofile = true

vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.ruler = false

-- lsp
vim.lsp.enable({ 'bash_ls', 'nil', 'hls', 'lua_ls', 'rust_analyzer' })
vim.lsp.config('bash_ls', {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh" },
})
vim.lsp.config('nil', {
	cmd = { "nil" },
	filetypes = { "nix" },
})
vim.lsp.config('rust_analyzer', {
	settings = {
		diagnostics = {
			styleLints = {
				enable = true,
			},
		},
	},
})
vim.lsp.config('*', {
	root_markers = { '.git' },
})

-- auto format on write
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		vim.lsp.buf.format()
	end
})

-- treesitter callback
vim.api.nvim_create_autocmd("Filetype", {
	callback = function(args)
		local ok = pcall(vim.treesitter.start, args.buf)
	end,
})

-- colors
vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff", bg = "#000000" })
vim.api.nvim_set_hl(0, "Diagnostic", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "Identifier", { fg = "#f9e2af" })
vim.api.nvim_set_hl(0, "@variable", { fg = "#f9a28f" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#6c7086" })
vim.api.nvim_set_hl(0, "Function", { fg = "#89b4fa" })
vim.api.nvim_set_hl(0, "Special", { fg = "#f5c2e7" })
vim.api.nvim_set_hl(0, "String", { fg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "Macro", { fg = "#94e2d5" })
