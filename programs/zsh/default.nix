{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      exa
    ];

    programs.zsh = {
      enable = true;
      shellAliases = {
        sudo = "doas";
        e = "exit";
        cat = "bat --style=plain";
        shutdown = "sudo shutdown now";
        reboot = "sudo reboot";
        youtube-dl="yt-dlp";
        info = "info --vi-keys";

        ls="exa";
        ll="exa -lbFh --git";
        l="exa -lbFha --git";
        la="exa -lbhHigmuSa --git --color-scale";
        lx="exa -lbhHigmuSa@ --git --color-scale";
        tree="exa --tree";
      };

      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        plugins = [ "git" "python" "man" "sudo" "history-substring-search" ];
        customPkgs = [ pkgs.zsh-history-substring-search ];
      };
    };

    # Font that p10k uses, nerd font includes icons
    fonts.fonts = with pkgs; [
      meslo-lgs-nf
    ];

    home-manager.users.huantian.programs = {
      zsh.enable = true;
      zsh.initExtraFirst= ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      zsh.initExtraBeforeCompInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

        # Better SSH/Rsync/SCP Autocomplete
        zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
        zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users

        # Use bat for manpages
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      '';
    };

    home-manager.users.huantian.home.file = {
      ".p10k.zsh".source = ./.p10k.zsh;
    };

  };
}
