{
  config,
  ...
}:
let
  cfg = config.custom;
in
{
  imports = [
    ./graphical
  ];

  config = {
    environment.localBinInPath = true;

    # Don't wait for dhcpd when booting
    networking.dhcpcd.wait = "background";

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Brussels";

    users.users.${config.custom.user} = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "wheel"
        "audio"
        "input"
        "video"
        "graphical"
        "dialout"
      ];
    };

    home-manager.users.root =
      { ... }:
      {
        home.stateVersion = cfg.stateVersion;
      };

    nix = {
      settings.trusted-users = [
        "branco"
        "root"
      ];
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older than 7d";
      };
      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };
    };
  };
}
