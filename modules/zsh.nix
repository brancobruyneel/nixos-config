{ config, lib, pkgs, ... }:

{
  options.custom.zsh = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.zsh.enable {
    users.users.${config.custom.user}.shell = pkgs.zsh;

    programs.zsh = {
      enable = true;
    };
  };
}
