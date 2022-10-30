{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
in
{
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
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

          " require('lspconfig').nil_ls.setup{
          "   settings = {
          "     cmd = { "${pkgs.nil}/bin/nil" }
          "   }
          " }
        '';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            lightline-vim
            lightline-lsp
            vimtex
          ];
        };
      };
    };

    environment.systemPackages = with pkgs;
      let
        clipboard-tool =
          if config.modules.desktop.wayland.enable
          then wl-clipboard
          else xclip;
      in
      [
        clipboard-tool
      ];
  };
}
