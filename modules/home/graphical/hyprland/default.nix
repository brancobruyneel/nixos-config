{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  enabled = osConfig.custom.graphical.hyprland.enable or false;
in
{
  config = lib.mkIf enabled {
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
      hyprshot
    ];

    services.gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };

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

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "~/pictures/wallpapers/simonstalenhag/svema/svema_26_big.jpg"
        ];
        wallpaper = [
          {
            monitor = "DP-1";
            path = "~/pictures/wallpapers/simonstalenhag/svema/svema_26_big.jpg";
          }
          {
            monitor = "DP-2";
            path = "~/pictures/wallpapers/simonstalenhag/svema/svema_26_big.jpg";
          }
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
}
