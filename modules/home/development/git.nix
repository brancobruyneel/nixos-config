{
  config,
  osConfig,
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

  config = lib.mkIf config.custom.git.enable {
    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
      settings.version = "1";
    };

    # Force overwrite existing gh config
    xdg.configFile."gh/config.yml".force = true;

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
          path = osConfig.age.secrets."git/work".path;
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
}
