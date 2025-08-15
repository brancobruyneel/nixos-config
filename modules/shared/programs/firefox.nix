{
  config,
  lib,
  ...
}:
{
  options.custom.firefox = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.firefox.enable {
    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        programs.firefox = {
          enable = true;
          profiles = {
            default = {
              settings = {
                "browser.startup.homepage" = "https://duckduckgo.com/";
                "browser.search.defaultenginename" = "ddg";
                "browser.search.order.1" = "ddg";
              };

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
              extraConfig = ''
                user_pref("extensions.autoDisableScopes", 0);
                user_pref("extensions.enabledScopes", 15);
              '';
            };
          };
        };
      };
  };
}
