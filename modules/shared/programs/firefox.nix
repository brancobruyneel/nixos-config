{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.firefox = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.firefox.enable {
    home-manager.users.${config.custom.user} = {pkgs, ...}: {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
              vimium
            ];
          };
        };
      };
    };
  };
}
