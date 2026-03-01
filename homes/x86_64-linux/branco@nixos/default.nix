{
  osConfig,
  pkgs,
  ...
}:
let
  cfg = osConfig.custom;
in
{
  custom = {
    firefox.enable = true;
    zen.enable = true;
    neovim.enable = true;
    discord.enable = true;
  };

  home.packages = with pkgs; [
    btop
    bat
    xdg-user-dirs
  ];

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
        "text/html" = [ "zen-beta.desktop" ];
        "x-scheme-handler/about" = [ "zen-beta.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
        "x-scheme-handler/unknown" = [ "zen-beta.desktop" ];
        "x-scheme-handler/msteams" = [ "teams.desktop" ];
      };
    };
  };

  home.file."pictures/wallpapers/simonstalenhag" = {
    source = ../../../media/wallpapers/simonstalenhag;
    recursive = true;
    executable = false;
  };
}
