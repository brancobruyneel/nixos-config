{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # https://github.com/NixOS/nixpkgs/issues/382612#issuecomment-2734556441
  boot.kernelParams = [ "module_blacklist=amdgpu" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.tailscale.enable = true;
  networking.networkmanager.enable = true;

  services.xserver.xkb = {
    layout = "us";
  };

  programs.steam.enable = true;

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  custom = {
    stateVersion = "24.11";

    development.enable = true;

    graphical.hyprland.enable = true;
    firefox.enable = true;
    neovim.enable = true;
    discord.enable = true;

    extraHomePackages = with pkgs; [
      mpv
      ffmpeg-full
      signal-desktop
      docker
      docker-compose
      go
      golangci-lint
      gopls
      gotestsum
    ];
  };
}
