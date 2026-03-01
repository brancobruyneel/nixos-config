{
  config,
  lib,
  pkgs,
  ...
}:
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
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    fonts = {
      fontDir.enable = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [
            "Symbola"
            "Noto Emoji"
          ];
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
        noto-fonts-color-emoji
        comic-relief
        nerd-fonts.jetbrains-mono
        open-sans
      ];
    };
  };
}
