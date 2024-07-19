{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.vim;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
          syntax on                       " Turn on syntax highlighting
          set number relativenumber       " Hybrid line numbers
          set clipboard+=unnamedplus      " Use system clipboard
          set mouse=nvih                  " mouse in normal, visual, insert, help
          set expandtab                   " Use spaces instead of tabs.
          set smarttab                    " Be smart using tabs ;)
          set tabstop=4                   " One tab == four spaces.
          set shiftwidth=0                " Use tabstop value for shiftwidth
          set backspace=indent,eol,start  " More powerful backspacing

          " Set lightline.vim theme
          let g:lightline = {'colorscheme': 'darcula',}
          " Always show statusline
          set laststatus=2
          " Uncomment to prevent non-normal modes showing in powerline and below powerline.
          set noshowmode

          let maplocalleader="\<space>"

          " Allow saving of files as sudo when I forgot to start vim using sudo.
          cmap w!! w !doas tee %

          " Associate .rdlevel with json
          au BufNewFile,BufRead *.rdlevel setlocal ft=json

          " Tab size for .nix files
          autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab

          lua << EOF

          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true
            }
          }

          local ht = require('haskell-tools')
          local bufnr = vim.api.nvim_get_current_buf()
          local def_opts = { noremap = true, silent = true, buffer = bufnr, }
          -- haskell-language-server relies heavily on codeLenses,
          -- so auto-refresh (see advanced configuration) is enabled by default
          vim.keymap.set('n', '<space>ca', vim.lsp.codelens.run, opts)
          -- Hoogle search for the type signature of the definition under the cursor
          vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
          -- Evaluate all code snippets
          vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
          -- Toggle a GHCi repl for the current package
          vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
          -- Toggle a GHCi repl for the current buffer
          vim.keymap.set('n', '<leader>rf', function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
          end, def_opts)
          vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
          EOF
        '';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            lightline-vim
            lightline-lsp
            vimtex
            haskell-tools-nvim
            plenary-nvim
            nvim-treesitter.withAllGrammars
            nvim-treesitter-textobjects
            nvim-cmp
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; let
      clipboard-tool =
        if config.modules.desktop.wayland.enable
        then wl-clipboard
        else xclip;
    in [
      clipboard-tool
    ];
  };
}
