{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.custom.graphical.hyprland;
in {
  options.custom.graphical.hyprland = {
    enable = mkOption {
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    home-manager.users.${config.custom.user} = {pkgs, ...}: {
      home.packages = with pkgs; [
        pamixer
        playerctl
        wl-clipboard
        adwaita-icon-theme
        adwaita-qt
        gnome-bluetooth
        libnotify
        networkmanagerapplet
        hyprpaper
      ];

      services.gnome-keyring = {
        enable = true;
        components = [ "secrets" ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        settings = import ./hyprland.nix;
      };

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = import ./waybar.nix;
      };

      services.dunst = {
        enable = true;
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [
            "~/pictures/wallpapers/simonstalenhag/svema/svema_12_big.jpg"
          ];
          wallpaper = [
            "DP-2,~/pictures/wallpapers/simonstalenhag/svema/svema_12_big.jpg"
            "DP-3,~/pictures/wallpapers/simonstalenhag/svema/svema_12_big.jpg"
          ];
        };
      };

      programs.wofi = import ./wofi.nix;

      programs.zsh.profileExtra = ''
        if uwsm check may-start -q; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      '';
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    fonts = {
      fontDir.enable = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = ["Symbola" "Noto Emoji"];
          monospace = ["JetBrainsMono Nerd Font"];
          serif = ["Source Serif Pro"];
        };
      };
      packages = with pkgs; [
        orbitron
        roboto
        roboto-mono
        roboto-slab
        source-serif
        source-sans-pro
        source-serif-pro
        source-code-pro
        fira-mono
        fira-code
        fira
        symbola
        noto-fonts-emoji
        comic-relief
        nerd-fonts.jetbrains-mono
        open-sans
      ];
    };
  };
}
