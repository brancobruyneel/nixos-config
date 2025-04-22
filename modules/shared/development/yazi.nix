{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.yazi = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.yazi.enable {
    environment.systemPackages = with pkgs; [
      yazi
    ];

    home-manager.users.${config.custom.user} = {pkgs, ...}: {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        flavors = let
          flavorsRepo = pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "flavors";
            rev = "main";
            hash = "sha256-nhIhCMBqr4VSzesplQRF6Ik55b3Ljae0dN+TYbzQb5s=";
          };
        in {
          catppuccin-frappe = flavorsRepo + "/catppuccin-frappe.yazi";
          catppuccin-latte = flavorsRepo + "/catppuccin-latte.yazi";
          catppuccin-macchiato = flavorsRepo + "/catppuccin-macchiato.yazi";
          catppuccin-mocha = flavorsRepo + "/catppuccin-mocha.yazi";
          dracula = flavorsRepo + "/dracula.yazi";
          onedark = pkgs.fetchFromGitHub {
            owner = "BennyOe";
            repo = "onedark.yazi";
            rev = "main";
            hash = "sha256-tfkzVa+UdUVKF2DS1awEusfoJEjJh40Bx1cREPtewR0=";
          };
        };
        keymap = {
          input.prepend_keymap = [
            {
              on = "<Esc>";
              run = "close";
              desc = "cancel input";
            }
          ];
        };
        theme = {
          flavor = {
            dark = "onedark";
          };
        };
      };
    };
  };
}
