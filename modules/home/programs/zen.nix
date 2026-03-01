{
  config,
  inputs,
  lib,
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
      suppressXdgMigrationWarning = true;
      policies = {
        DisableAppUpdate = true;
      };
    };
  };
}
