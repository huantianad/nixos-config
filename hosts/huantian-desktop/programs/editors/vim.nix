{ config, pkgs, lib, inputs, ... }:

let
  myVim = pkgs.vim_configurable.customize {
    name = "vim";

    vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
      start = [ lightline-vim vim-toml vimsence vim-lsp ];
    };

    vimrcConfig.customRC = ''
      " Allow saving of files as sudo when I forgot to start vim using sudo.
      cmap w!! w !doas tee %

      syntax on                       " Turn on syntax highlighting
      set number relativenumber       " Hybrid line numbers
      set clipboard=unnamedplus       " Use system clipboard
      set mouse=nicr                  " Mouse scrolling
      set expandtab                   " Use spaces instead of tabs.
      set smarttab                    " Be smart using tabs ;)
      set shiftwidth=4                " One tab == four spaces.
      set tabstop=4                   " One tab == four spaces.
      set backspace=indent,eol,start  " More powerful backspacing

      " Tab size for .nix files
      autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab

      " Use the x key as cut instead of d
      nnoremap x d
      xnoremap x d
      noremap xx dd
      nnoremap X D

      " Status Line

      " The lightline.vim theme
      let g:lightline = {'colorscheme': 'darcula',}

      " Always show statusline
      set laststatus=2

      " Uncomment to prevent non-normal modes showing in powerline and below powerline.
      set noshowmode

      " Associate .rdlevel with json
      au BufNewFile,BufRead *.rdlevel setlocal ft=json

      """ vim-lsp settings """
      if executable('rnix-lsp')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'rnix-lsp',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, 'rnix-lsp']},
            \ 'whitelist': ['nix'],
            \ })
      endif
    '';
  };
in
{
  config = {
    programs.vim.defaultEditor = true;
    environment.systemPackages = with pkgs; [
      myVim
      rnix-lsp
    ];
  };
}
