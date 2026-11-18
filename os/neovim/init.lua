vim.g.mapleader = " "
vim.opt.wrap = false
vim.keymap.set("n", "<C-w>", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end)

-- Autocomplete (nvim-cmp)
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
	enabled = function()
		return false
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	sources = {
		-- {name = 'path'},
		{ name = 'nvim_lsp', keyword_length = 1 },
		-- {name = 'buffer', keyword_length = 3},
		{ name = 'luasnip' },
	},
	window = {
		documentation = cmp.config.window.bordered()
	},
	formatting = {
		fields = { 'menu', 'abbr', 'kind' },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = 'λ',
				luasnip = '⋗',
				-- buffer = 'Ω',
				-- path = '🖫',
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				fallback()
			end
		end),
		['<C-n>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item(select_opts)
			else
				fallback()
			end
		end),

		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	},
})

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
			signs = { severity = ERROR },
			underline = { severity = ERROR },
			jump = { severity = ERROR },
			float = { severity = ERROR }
		})
	end)
	vim.keymap.set("n", "<leader>w", function()
		config({
			signs = { severity = WARN },
			underline = { severity = WARN },
			jump = { severity = WARN },
			float = { severity = WARN }
		})
	end)
	vim.keymap.set("n", "<leader>d", function()
		config({
			signs = true,
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

-- format keybind
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- lsp
vim.lsp.enable({ 'wgsl-analyzer', 'bash_ls', 'nil', 'hls', 'lua_ls', 'rust_analyzer' })
vim.lsp.config('wgsl-analyzer', {
	cmd = { "wgsl-analyzer" },
	filetypes = { "wgsl" },
})
vim.lsp.config('bash_ls', {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh" },
})
vim.lsp.config('nil', {
	cmd = { "nil" },
	filetypes = { "nix" },
	settings = {
		["nil"] = {
			nix = {
				flake = {
					autoArchive = true,
				},
			},
		},
	},
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
