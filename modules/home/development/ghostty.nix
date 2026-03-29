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
    programs.ghostty =
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
        enable = true;
        package = ghosttyPkg;
        enableZshIntegration = true;
        settings = {
          "font-family" = "JetBrainsMono Nerd Font";
          "font-size" = fontSize;
          "window-decoration" = "false";
          "theme" = "One Half Dark";
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
}
