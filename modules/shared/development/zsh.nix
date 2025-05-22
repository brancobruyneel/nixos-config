{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.zsh = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.zsh.enable {
    users.users.${config.custom.user}.shell = pkgs.zsh;
    programs.zsh.enable = true;

    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        programs.zsh = {
          enable = true;
          shellAliases = {
            # nix
            nrb = "sudo nixos-rebuild switch --flake ~/.config/nix";
            drb = "sudo darwin-rebuild switch --flake ~/.config/nix";

            # git
            gd = "git diff";
            gdc = "git diff --cached";
            gs = "git status --short";
            ga = "git add -vu";
            gA = "git add -vA";
            gc = "git commit";
            gcm = "git commit -m";
            gca = "git commit -a";
            gcam = "git commit -am";
            gco = "git checkout";
            gcob = "git checkout -b";
            gp = "git pull";
            gpp = "git git pull && push";

            # Pretty logs
            gl = "git log --graph --abbrev-commit --decorate --date=relative --format=format:\"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)\" --all";

            v = "nvim";

            sd = "sudo shutdown now";
            rb = "sudo reboot now";

            ls = "ls --color=auto";
            ll = "ls -lh";
            la = "ls -a";
            lla = "ls -lah";

            grep = "grep --color=auto";
            diff = "diff --color=auto";

            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";

            f = "yy"; # yazi

            tf = "terraform";

            # glab
            glrv = "glab repo view -w";
            glcr = "glab ci run | tee /dev/tty | grep -o 'https://[^ ]*' | xargs open";

            # tmux
            t = "tmux new -s";
            ta = "tmux at";
            tk = "pkill tmux";
            tls = "tmux ls";
            tsd = "tmux-sync-dirs";

            # docker
            dps = "docker ps --format \"table {{ .ID }}\t{{.Names}}\t{{.Status}}\t{{.Ports}}\"";
          };

          history.size = 1000;
          history.path = "$HOME/.zsh_history";

          initContent = lib.mkBefore ''
            # vi mode
            bindkey -v
            bindkey '^R' history-incremental-search-backward
            bindkey -v '^?' backward-delete-char

            # tmux
            bindkey -s '^f' 'tmux-sessionizer\n'
            bindkey -s '^s' 'tmux-switch-session\n'
          '';
        };

        programs.fzf = {
          enable = true;
          enableZshIntegration = true;
        };

        programs.starship = {
          enable = true;
          enableZshIntegration = true;
        };
      };
  };
}
