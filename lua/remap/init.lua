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

