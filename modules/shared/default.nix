{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [
    ./development
    ./programs
  ];

  options.custom = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "branco";
      default = "branco";
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

    homeStateVersion = lib.mkOption {
      default = config.custom.stateVersion;
    };
    systemStateVersion = lib.mkOption {
      default = config.custom.stateVersion;
    };
    stateVersion = lib.mkOption {
      example = "24.11";
    };
  };

  config = {
    environment.systemPackages = with pkgs;
      [
        neovim
        coreutils
        git
        jq
        btop
        ripgrep
        wget
        zip
        unzip
        dnsutils
        nmap
      ]
      ++ cfg.extraSystemPackages;

    environment.variables.EDITOR = "nvim";

    nix = {
      settings.experimental-features = ["nix-command" "flakes"];
    };

    nixpkgs.config.allowUnfree = true;

    users.users.${config.custom.user} = {
      description = "Branco Bruyneel";
    };

    home-manager = {
      useGlobalPkgs = true;
      users = {
        "${config.custom.user}" = {...}: {
          home.stateVersion = cfg.homeStateVersion;
          home.packages = cfg.extraHomePackages;

          programs.direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };
        };
      };
    };

    system.stateVersion = cfg.systemStateVersion;
  };
}
