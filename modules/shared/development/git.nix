{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.git = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = let
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
        # includes = [
        #   {
        #     condition = "gitdir:~/work/**";
        #     path = config.age.secrets."git/work".path;
        #   }
        # ];
        ignores = [
          ".DS_Store"
          ".data"
          ".direnv"
          ".envrc"
          ".dir-locals.el"
        ];
      };
    };
  in
    lib.mkIf config.custom.git.enable {
      # age.secrets = {
      #   "git/work" = {
      #     file = ../../../secrets/git/work.age;
      #     owner = config.custom.user;
      #   };
      # };
      home-manager.users.${config.custom.user} = {...}: base;
    };
}
