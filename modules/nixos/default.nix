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
    ./grahpical
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

    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        home.stateVersion = cfg.stateVersion;
        home.packages =
          with pkgs;
          [
            btop
            bat
            xdg-user-dirs
          ]
          ++ cfg.extraHomePackages;

        xdg = {
          enable = true;
          portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
          userDirs = {
            enable = true;
            createDirectories = true;
            desktop = "/home/${cfg.user}/desktop";
            documents = "/home/${cfg.user}/documents";
            download = "/home/${cfg.user}/downloads";
            music = "/home/${cfg.user}/music";
            pictures = "/home/${cfg.user}/pictures";
            publicShare = "/home/${cfg.user}/desktop";
            videos = "/home/${cfg.user}/videos";
          };
          mimeApps = {
            enable = true;
            defaultApplications = {
              "text/html" = [ "firefox.desktop" ];
              "x-scheme-handler/about" = [ "firefox.desktop" ];
              "x-scheme-handler/http" = [ "firefox.desktop" ];
              "x-scheme-handler/https" = [ "firefox.desktop" ];
              "x-scheme-handler/unknown" = [ "firefox.desktop" ];
              "x-scheme-handler/msteams" = [ "teams.desktop" ];
            };
          };
        };

        home.file."pictures/wallpapers/simonstalenhag" = {
          source = ./../../media/wallpapers/simonstalenhag;
          recursive = true;
          executable = false;
        };

        programs.ssh.enable = true;
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
