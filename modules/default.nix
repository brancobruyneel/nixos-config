{ config, lib, pkgs, ... }:
let
  cfg = config.custom;
in
{
  imports = [
    ./grahpical/hyprland
    ./git.nix
    ./ghostty.nix
    ./tmux.nix
    ./zsh.nix
    ./firefox.nix
  ];

  options.custom = {
    user = lib.mkOption {
      example = "branco";
      default = "branco";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
    };

    extraSystemPackages = lib.mkOption {
      default = [ ];
      example = [ pkgs.unzip ];
    };

    extraHomePackages = lib.mkOption {
      default = [ ];
      example = [ pkgs.spotify-tui ];
    };

    stateVersion = lib.mkOption {
      example = "24.11";
    };

    permittedInsecurePackages = lib.mkOption {
      default = [ ];
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      jq
      btop
      ripgrep
      wget
      zip
      dnsutils
      nmap
      neovim
    ] ++ cfg.extraSystemPackages;

    # Don't wait for dhcpd when booting
    networking.dhcpcd.wait = "background";

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Brussels";

    users.users.${config.custom.user} = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "audio" "input" "video" "graphical" "dialout" ];
    };

    home-manager.users.root = { ... }: {
      home.stateVersion = cfg.stateVersion;
    };

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.stateVersion = cfg.stateVersion;
      home.packages = with pkgs; [
        btop
        bat
      ] ++ cfg.extraHomePackages;
    };

    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
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
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
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
