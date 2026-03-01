{
  config,
  pkgs,
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

    environment.systemPackages =
      with pkgs;
      [
        jq
        btop
        ripgrep
        wget
        zip
        dnsutils
        nmap
      ]
      ++ cfg.extraSystemPackages;

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
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
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

    nixpkgs.config.allowUnfree = true;
  };
}
