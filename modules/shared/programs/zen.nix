{
  config,
  lib,
  inputs,
  ...
}:
{
  options.custom.zen = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.zen.enable {
    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        imports = [ inputs.zen-browser.homeModules.beta ];

        programs.zen-browser = {
          enable = true;
          policies = {
            DisableAppUpdate = true;
          };
        };
      };
  };
}
