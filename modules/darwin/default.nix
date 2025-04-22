{config, ...}: let
  cfg = config.custom;
in {
  imports = [./graphical];

  config = {
    users.users.${cfg.user}.home = "/Users/${cfg.user}";

    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = cfg.user;
      autoMigrate = true;
    };
  };
}
