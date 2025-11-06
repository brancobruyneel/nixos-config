{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.ghostty = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.ghostty.enable {
    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      let
        ghosttyPkg =
          if pkgs.stdenv.isDarwin then
            pkgs.writeShellScriptBin "ghostty-mock" ''
              true
            ''
          else
            pkgs.ghostty;
        fontSize = if pkgs.stdenv.isDarwin then "16" else "12";
      in
      {
        programs.ghostty = {
          enable = true;
          package = ghosttyPkg;
          settings = {
            "font-family" = "JetBrainsMono Nerd Font";
            "font-size" = fontSize;
            "window-decoration" = "false";
            "theme" = "OneHalfDark";
            "font-thicken" = "true";
            "background" = "#1e222a";
            "foreground" = "#abb2bf";
            "cursor-style" = "block";
            "cursor-style-blink" = "false";
            "shell-integration-features" = "no-cursor";
            "confirm-close-surface" = "false";
            "window-padding-y" = "10";
            "window-padding-x" = "10";
          };
        };
      };
  };
}
