{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.tmux = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.tmux.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "tmux-sessionizer" (builtins.readFile ./tmux-sessionizer.sh))
      (pkgs.writeShellScriptBin "tmux-switch-session" (builtins.readFile ./tmux-switch-session.sh))
      (pkgs.writeShellScriptBin "tmux-sync" (builtins.readFile ./tmux-sync.sh))
    ];

    programs.tmux.enable = true;

    home-manager.users.${config.custom.user} = {pkgs, ...}: {
      programs.tmux = {
        enable = true;
        shortcut = "a";
        keyMode = "vi";
        terminal = "tmux-256color";
        plugins = with pkgs.tmuxPlugins; [
          yank
          resurrect
          (pkgs.tmuxPlugins.mkTmuxPlugin {
            name = "onedark-tmux";
            pluginName = "onedark-theme";
            rtpFilePath = "onedark.tmux";
            src = pkgs.fetchFromGitHub {
              owner = "brancobruyneel";
              repo = "onedark-tmux";
              rev = "main";
              hash = "sha256-d1U1AGwT7mCSL4bIGQEw735RTW+D7Vmnr3HgWklDa9U=";
            };
          })
        ];
        extraConfig = ''
          set-option -sa terminal-overrides ",xterm*:Tc"
          set -g mouse on

          # Start windows and panes at 1, not 0
          set -g base-index 1
          set -g pane-base-index 1
          set-window-option -g pane-base-index 1
          set-option -g renumber-windows on

          # Vim style pane selection
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind < resize-pane -L 10
          bind > resize-pane -R 10
          bind - resize-pane -D 10
          bind + resize-pane -U 10

          bind @ choose-window 'join-pane -h -s "%%"'
          bind C-@ choose-window 'join-pane    -s "%%"'

          # Sessions
          bind s run-shell -b tmux-switch-session
          bind f run-shell -b tmux-sessionizer

          bind b set-option status

          # Image preview
          set -g allow-passthrough on
          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          # Vi copy mode
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

          set -g @onedark_flavour 'dark'
        '';
      };
    };
  };
}
