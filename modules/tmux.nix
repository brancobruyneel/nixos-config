{ config, lib, pkgs, ... }:

{
	options.custom.tmux = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

	config = lib.mkIf config.custom.tmux.enable {
		programs.tmux = {
			enable = true;
			shortcut = "a";
			keyMode = "vi";
			terminal = "tmux-256color";
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

				bind   @ choose-window 'join-pane -h -s "%%"'
				bind C-@ choose-window 'join-pane    -s "%%"'

				# sessions
				bind s run-shell -b tmux-switch-session
				bind f run-shell -b tmux-sessionizer

				bind b set-option status

				# vi copy mode
				bind-key -T copy-mode-vi v send-keys -X begin-selection
				bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
			'';
		};
	};
}
