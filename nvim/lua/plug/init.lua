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
call plug#end()
]]
