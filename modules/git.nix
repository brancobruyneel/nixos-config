{ config, lib, pkgs, ... }:
{
  options.custom.git = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config =
    let
      base = {
        programs.git = {
          enable = true;
          userEmail = "branco.bruyneel@gmail.com";
          userName = "Branco Bruyneel";
          extraConfig = {
            init.defaultBranch = "main";
            branch.autosetuprebase = "always";
            pull.rebase = true;
            rebase.autoStash = true;
            push.autoSetupRemote = true;
            core.autocrlf = "input";
          };
          ignores = [
            ".data/"
            ".direnv"
            ".envrc"
            "shell.nix"
          ];
        };
      };
    in
    lib.mkIf config.custom.git.enable {
      home-manager.users.${config.custom.user} = { ... }: base;
      home-manager.users.root = { ... }: base;
    };
}
