{
  config,
  lib,
  ...
}:
{
  options.custom.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
    includeWork = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config =
    let
      user = config.custom.user;

      base = {
        programs.git = {
          enable = true;
          userName = "brancobruyneel";
          userEmail = "43569324+brancobruyneel@users.noreply.github.com";
          extraConfig = {
            init.defaultBranch = "main";
            branch.autosetuprebase = "always";
            pull.rebase = true;
            rebase.autoStash = true;
            push.autoSetupRemote = true;
            core.autocrlf = "input";
          };

          includes = lib.mkIf config.custom.git.includeWork [
            {
              condition = "gitdir:~/work/**";
              path = config.age.secrets."git/work".path;
            }
          ];

          aliases = {
            d = "diff";
            dc = "diff --cached";
            s = "status --short";
            a = "add -vu";
            A = "add -vA";
            c = "commit";
            cm = "commit -m";
            ca = "commit -a";
            cam = "commit -am";
            co = "checkout";
            cob = "checkout -b";
            p = "pull";
            pp = "git pull && push";
            l = "log --graph --abbrev-commit --decorate --date=relative --format=format:\"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)\" --all"; # Pretty logs
          };

          ignores = [
            ".DS_Store"
            ".data"
            ".direnv"
            ".envrc"
            ".dir-locals.el"
          ];
        };
      };

      secrets = lib.mkIf config.custom.git.includeWork {
        "git/work" = {
          file = ../../../secrets/git/work.age;
          owner = user;
        };
      };
    in
    lib.mkIf config.custom.git.enable {
      age.secrets = secrets;
      home-manager.users.${user} = { ... }: base;
    };
}
