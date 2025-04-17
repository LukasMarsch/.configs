vim.cmd [[
call plug#begin(stdpath('data') . '/plugged')
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
	Plug 'nvim-treesitter/playground'
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'L3MON4D3/LuaSnip'
	Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
    Plug 'm4xshen/autoclose.nvim'
    Plug 'ThePrimeagen/refactoring.nvim'
call plug#end()
]]

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

require('refactoring').setup()

require('mason').setup({})
require('mason-lspconfig').setup({
   handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    }
})

local lsp_zero = require('lsp-zero').preset({})
local lsp_attach = function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
end

lsp_zero.extend_lspconfig({
    capabilitites = require('cmp_nvim_lsp').default_capabilities(),
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = true,
})

local cmp =  require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp_zero.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp_zero.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
end)

lsp_zero.setup()

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

require('nvim-treesitter.configs').setup {
-- A list of parser names, or "all" (the five listed parsers should always be installed)
ensure_installed = { "c", "lua", "vim", "vimdoc", "query"},
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
	enable = false,
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

require('autoclose').setup()

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

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- telescope
vim.keymap.set('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>')

-- move ops
vim.keymap.set('v', "J", ":m '>+1<cr>gv=gv")
vim.keymap.set('v', "K", ":m '<-2<cr>gv=gv")
vim.keymap.set('n', '<C-s>', ':w<cr>')

-- jumping
vim.keymap.set('n', '<C-u>', '<C-u>z.')
vim.keymap.set('n', '<C-d>', '<C-d>z.')

-- searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

