# infinity-nvim
## an infinity-colored nvim config for Windows
---

All commands are to be executed in powershell 

If you don't feel comfortable with the command line yet, start with a barebones nvim install and do the `:Tutor`
to install:

- Install [Alacritty](https://alacritty.org)
- Install latest pwsh version

    ```powershell
    winget install pwsh
    ```

- (install my [infinity-alacritty](https://github.com/LukasMarsch/infinity-alacritty) theme for a matching terminal experience)   
- or configure alacritty however you please
- Install [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/latest) and import it to Windows
- Install Neovim


    ```powershell
    winget install --id=Neovim.Neovim  -e`
    ```

- Copy the nvim folder from this project into $HOME\AppData\Local\ folder

    ```powershell
    git clone https://github.com/LukasMarsch/infinity-nvim.git;
    $nvim_path = "~\AppData\Local\nvim"
    mkdir $nvim_path;
    mv .\infinity-nvim\. $nvim_path -Recurse
    ```

- Install [Plug Package Manager](https://github.com/junegunn/vim-plug#windows-powershell-1) for Neovim 

- Start Neovim by opening Alacritty and typing

    ```powershell
    nvim .
    ```

- If you are greeted with netrw, you have done everything correct!
- Ensure you are in Normal mode (see bottom left), if not press `<Esc>`
- Type `:PlugInstall` to install all configured extensions
- This includes:
  - nvim-telescope/telescope.nvim
  - nvim-lua/plenary.nvim
  - nvim-tree/nvim-web-devicons
  - nvim-lualine/lualine.nvim
  - nvim-treesitter/nvim-treesitter
  - catppuccin/nvim
  - nvim-treesitter/playground
  - neovim/nvim-lspconfig
  - williamboman/mason.nvim
  - williamboman/mason-lspconfig.nvim
  - hrsh7th/nvim-cmp
  - hrsh7th/cmp-nvim-lsp
  - L3MON4D3/LuaSnip
  - VonHeikemen/lsp-zero.nvim
- I encourage you to read all their documentation to understand my config
- This config is not set in stone, feel free to mix it up to make it your personal editor <3
