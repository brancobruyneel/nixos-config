# https://gitlab.com/fazzi/nixohess/-/blob/main/home/modules/apps/discord/default.nix?ref_type=heads#L121

{
  pkgs,
  lib,
  config,
  ...
}: let
  commandLineArgs =
    [
      "--enable-features=WaylandLinuxDrmSyncobj" # fix flickering
    ];
  joinedArgs = lib.concatStringsSep " " commandLineArgs;


  # override for electron 36
  electronVer = "36.0.0-beta.9";
  electronPkg = pkgs.electron_35-bin.overrideAttrs {
    pname = "electron_36-bin";
    version = electronVer;
    src = pkgs.fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${electronVer}/electron-v${electronVer}-linux-x64.zip";
      sha256 = "sha256-i09lv+qgpeA9P+WBPLosOxhpaLlgp0IbFdFZZaiCZOw=";
    };
  };
in {
  options.custom.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.custom.discord.enable {
    home-manager.users.${config.custom.user} = {pkgs, ...}: {
    home.packages = with pkgs; [
      ((vesktop.override {
          electron = electronPkg;
          withTTS = false;
          withMiddleClickScroll = true;
        })
        .overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
          postFixup = ''
            ${old.postFixup or ""}
            wrapProgramShell $out/bin/vesktop --add-flags "${joinedArgs}"
          '';
        }))
    ];
    };
  };
}
