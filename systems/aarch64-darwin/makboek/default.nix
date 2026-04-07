{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = lib.optionals (builtins.pathExists ./private.nix) [ ./private.nix ];
  networking.computerName = "makboek";

  custom = {
    user = "branco";
    homeStateVersion = "24.11";
    systemStateVersion = 5;

    graphical.aerospace.enable = true;
  };

  age.secrets."git/work" = {
    file = ../../../secrets/git/work.age;
    owner = "branco";
  };

  age.secrets.trellis-api-key = {
    file = ../../../secrets/keys/trellis-api.age;
    mode = "400";
    owner = "branco";
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  services = {
    openssh.enable = true;
    tailscale.enable = false;
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "figma"
      "ghostty"
      "philips-hue-sync"
      "raycast"
      "zoom"
      "spotify"
    ];
    onActivation.cleanup = "zap";
  };

  fonts.packages = with pkgs; [
    roboto
    fira-mono
    fira-code
    fira
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  system = {
    primaryUser = config.custom.user;
    defaults = {
      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        launchanim = false;
        minimize-to-application = true;
        show-recents = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
      };

      loginwindow.GuestEnabled = false;
      menuExtraClock.ShowSeconds = true;

      WindowManager.EnableStandardClickToShowDesktop = false;

      trackpad = {
        Clicking = true;
        Dragging = true;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };
    };
    startup.chime = false;
  };

}
