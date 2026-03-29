{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom;
in
{
  options.custom = {
    user = lib.mkOption {
      type = lib.types.str;
      example = "branco";
      default = "branco";
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
    environment.systemPackages =
      with pkgs;
      [
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
        eza
      ];

    environment.variables.EDITOR = "nvim";

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    users.users.${cfg.user} = {
      description = "Branco Bruyneel";
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;

    system.stateVersion = cfg.systemStateVersion;
  };
}
