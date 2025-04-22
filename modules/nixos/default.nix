{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [
    ./grahpical
  ];

  options.custom = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "branco";
      default = "branco";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
    };

    extraSystemPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      example = [pkgs.unzip];
    };

    extraHomePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      example = [pkgs.spotify-tui];
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      example = "24.11";
    };

    permittedInsecurePackages = lib.mkOption {
      default = [];
    };
  };

  config = {
    environment.localBinInPath = true;

    environment.systemPackages = with pkgs;
      [
        jq
        btop
        ripgrep
        wget
        zip
        dnsutils
        nmap
        neovim
      ]
      ++ cfg.extraSystemPackages;

    # Don't wait for dhcpd when booting
    networking.dhcpcd.wait = "background";

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Brussels";

    users.users.${config.custom.user} = {
      isNormalUser = true;
      createHome = true;
      extraGroups = ["wheel" "audio" "input" "video" "graphical" "dialout"];
    };

    home-manager.users.root = {...}: {
      home.stateVersion = cfg.stateVersion;
    };

    home-manager.users.${config.custom.user} = {pkgs, ...}: {
      home.stateVersion = cfg.stateVersion;
      home.packages = with pkgs;
        [
          btop
          bat
          xdg-user-dirs
        ]
        ++ cfg.extraHomePackages;

      xdg = {
        enable = true;
        userDirs = {
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
            "text/html" = ["firefox.desktop"];
            "x-scheme-handler/about" = ["firefox.desktop"];
            "x-scheme-handler/http" = ["firefox.desktop"];
            "x-scheme-handler/https" = ["firefox.desktop"];
            "x-scheme-handler/unknown" = ["firefox.desktop"];
            "x-scheme-handler/msteams" = ["teams.desktop"];
          };
        };
      };
    };

    nix = {
      settings.experimental-features = ["nix-command" "flakes"];
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older than 7d";
      };
      optimise = {
        automatic = true;
        dates = ["daily"];
      };
    };

    nixpkgs.config.allowUnfree = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = cfg.stateVersion; # Did you read the comment?
  };
}
