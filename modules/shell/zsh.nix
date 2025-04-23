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
  cfg = config.modules.shell.zsh;
in {
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
      fzf
      zoxide
      pokeget-rs
    ];

    programs.zsh = {
      enable = true;
      shellAliases = {
        e = "exit";
        cat = "bat --style=plain";
        youtube-dl = "yt-dlp";
        info = "info --vi-keys";
        grep = "rg";
        ssh = "kitten ssh";

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

      histFile = "$XDG_STATE_HOME/zsh/history";

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

      shellInit = ''
      '';

      interactiveShellInit = ''
        # folders for history and completion files
        mkdir -p $XDG_CACHE_HOME/zsh $XDG_STATE_HOME/zsh
        compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        eval "$(zoxide init zsh --cmd cd)"

        pokeget random
      '';
    };

    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # .zshrc location
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

      # Use bat for manpages
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };

    programs.starship = {
      enable = true;
      presets = [
        "nerd-font-symbols"
      ];
      settings = {
        command_timeout = 1000;

        git_status = {
          conflicted = "~$count";
          stashed = "*$count";
          deleted = "✘$count";
          renamed = "»$count";
          modified = "!$count";
          staged = "+$count";
          untracked = "?$count";
          ahead = "⇡$count";
          diverged = "⇡\${ahead_count}⇣\${behind_count}";
          behind = "⇣$count";
        };
      };
    };

    home-manager.users.huantian.home.file = {
      ".config/tealdeer/config.toml".text = ''
        [updates]
        auto_update = true
      '';
    };
  };
}
