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
      profiles."default" = {
        isDefault = true;

        search = {
          force = true;
          default = "ddg";
        };

        extensions.packages = import ./browser-extensions.nix { inherit pkgs; };
      };
    };
  };
}
