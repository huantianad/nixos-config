{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eza
      killall
      btop
      wget
      tealdeer
      file
      bat
      ripgrep
      age
      sops
    ];

    programs.zsh = {
      enable = true;
      shellAliases = {
        e = "exit";
        cat = "bat --style=plain";
        youtube-dl = "yt-dlp";
        info = "info --vi-keys";
        grep = "rg";

        bump = "nix flake update --commit-lock-file";
        # quickly remove all result symlinks in current folder
        ur = "find . -maxdepth 1 -type l -name 'result*' -delete";
        gohugo = "cd /var/www/website && git pull && nix develop --command bash -c 'hugo -d ../huantian.dev/'";

        eza = "eza --group-directories-first";
        ls = "eza";
        ll = "eza -lbh --git";
        l = "eza -lbha --git";
        la = "eza -lbhHigmuSa --git --color-scale";
        lx = "eza -lbhHigmuSa@ --git --color-scale";
        tree = "eza --tree";
      };

      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "python"
          "man"
          "sudo"
          "history-substring-search"
          # "rust"
        ];
      };
    };

    home-manager.users.huantian.programs = {
      zsh.enable = true;
      zsh.initExtraFirst = ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      zsh.initExtraBeforeCompInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./p10k.zsh}

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

        # Better SSH/Rsync/SCP Autocomplete
        zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
        zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users

        # Use bat for manpages
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"

        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_STATE_HOME="$HOME/.local/state"
        export XDG_CACHE_HOME="$HOME/.cache"
      '';
    };

    home-manager.users.huantian.home.file = {
      ".config/tealdeer/config.toml".text = ''
        [updates]
        auto_update = true
      '';
    };
  };
}
