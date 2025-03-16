{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.custom.graphical.hyprland;
in
{
  options.custom.graphical.hyprland = {
    enable = mkOption {
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        pamixer
        playerctl
        wl-clipboard
        adwaita-icon-theme
        adwaita-qt
        gnome-bluetooth
        libnotify
        networkmanagerapplet
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
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

      programs.wofi = import ./wofi.nix;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal = {
      enable = true;
      config.preferred = {
        default = "gtk";
        "org.freedesktop.impl.portal.Screencast" = "hyprland";
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-hyprland ];
    };

    fonts = {
      fontDir.enable = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [ "Symbola" "Noto Emoji" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
          serif = [ "Source Serif Pro" ];
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
