{
  config,
  lib,
  pkgs,
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

          extensions.packages = import ./browser-extensions.nix { inherit pkgs; };
          extraConfig = ''
            user_pref("extensions.autoDisableScopes", 0);
            user_pref("extensions.enabledScopes", 15);
          '';
        };
      };
    };
  };
}
