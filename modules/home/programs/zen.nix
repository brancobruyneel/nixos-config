{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  options.custom.zen = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.zen.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
      };
      profiles."Default Profile" = {
        isDefault = true;
        path = "zfanmkyg.Default Profile";

        search = {
          force = true;
          default = "ddg";
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          vimium
          onepassword-password-manager
        ];
      };
    };
  };
}
