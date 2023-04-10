{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = ''
        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # enable mouse mode
        set -g mouse on
      '';
    };
  };
}
