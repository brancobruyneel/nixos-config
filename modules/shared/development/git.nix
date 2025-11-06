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
          settings = {
            user.name = "brancobruyneel";
            user.email = "43569324+brancobruyneel@users.noreply.github.com";
            extraConfig = {
              init.defaultBranch = "main";
              branch.autosetuprebase = "always";
              pull.rebase = true;
              rebase.autoStash = true;
              push.autoSetupRemote = true;
              core.autocrlf = "input";
            };

          };
          includes = lib.mkIf config.custom.git.includeWork [
            {
              condition = "gitdir:~/work/**";
              path = config.age.secrets."git/work".path;
            }
          ];

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
