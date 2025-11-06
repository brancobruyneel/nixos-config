{
  pkgs,
  tfpkg,
  config,
  inputs,
  ...
}:
{
  networking.computerName = "makboek";

  custom = {
    user = "branco";
    homeStateVersion = "24.11";
    systemStateVersion = 5;

    graphical.aerospace.enable = true;

    development.enable = true;
    git.includeWork = true;
    firefox.enable = true;

    extraHomePackages =
      with pkgs;
      [
        _1password-cli
        air
        agenix-cli
        aws-vault
        awscli2
        devenv
        colima
        delve
        discord
        docker
        docker-compose
        ffmpeg
        fioctl
        glab
        go
        golangci-lint
        gopls
        gofumpt
        go-task
        gotestsum
        keycastr
        mqttui
        mqttx-cli
        obsidian
        signal-desktop-bin
        spotify
        natscli
        tfpkg.terraform
        bruno
      ]
      ++ [
        inputs.nix-ai-tools.packages.${pkgs.system}.crush
      ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  services = {
    openssh.enable = true;
    tailscale.enable = true;
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
