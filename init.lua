require('remap')
require('plug')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50
vim.opt.colorcolumn = "160"

vim.cmd[[
	let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
	let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
	let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
	let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
	set shellquote= shellxquote=
]]

require('nvim-web-devicons').setup {
	r_icons = true;
	default = true;
	strict = true;

	override_by_filename = {
		[".gitignore"] = {
		icon = "",
		color = "#f1502f",
		name = "Gitignore"
		}
	};
}

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {
		statusline = {},
		winbar = {},
	},
	ignore_focus = {},
	always_divide_middle = true,
	globalstatus = false,
	refresh = {
		statusline = 1000,
		tabline = 1000,
		winbar = 1000,
		}
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
		},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}
require'nvim-treesitter.configs'.setup {
-- A list of parser names, or "all" (the five listed parsers should always be installed)
ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust"},
-- Install parsers synchronously (only applied to `ensure_installed`)
sync_install = false,
-- Automatically install missing parsers when entering buffer
-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
auto_install = true,
-- List of parsers to ignore installing (for "all")
ignore_install = { "javascript" },
---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
highlight = {
	enable = true,
	disable = {},
	-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
	disable = function(lang, buf)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	if ok and stats and stats.size > max_filesize then
	return true
	end
	end,
	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	-- Using this option may slow down your editor, and you may see some duplicate highlights.
	-- Instead of true it can also be a list of languages
	},
}


local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({buffer = bufnr})
end)
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

require('catppuccin').setup {
	flavour = 'mocha',
	background = {
		light = 'latte',
		dark = 'mocha',
	},
	dim_inactive = {
		enabled = true,
		shade = 'dark',
		percentage = 0.15,
	},
	styles = {
		comments = { 'italic' },
		contitionals = { 'bold' },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {
		mocha = {
			overlay0 = '#ffffff',
			surface2 = '#d4a935',
			base = '#1E222A',
			mantle = '#1c212b',
		},
	},
}

vim.cmd("colorscheme catppuccin")


