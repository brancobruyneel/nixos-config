{
  config,
  pkgs,
  inputs,
  ...
}: {
  networking.computerName = "makboek";

  custom = {
    user = "branco";
    homeStateVersion = "24.11";
    systemStateVersion = 5;

    graphical.aerospace.enable = true;

    development.enable = true;
    firefox.enable = true;

    extraHomePackages = with pkgs; [
      spotify
      keycastr
      discord
      zoom-us
      go
      glab
      gopls
      golangci-lint
      gotestsum
      delve
      docker
      docker-compose
      colima
      fioctl
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };

  homebrew = {
    enable = true;
    casks = [
      "raycast"
      "ghostty"
      "1password"
    ];
    onActivation.cleanup = "zap";
  };

  fonts.packages = with pkgs; [
    roboto
    fira-mono
    fira-code
    fira
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
  ];

  system = {
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
