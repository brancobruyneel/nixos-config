{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.videoDrivers = ["nvidia"];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  custom = {
    stateVersion = "24.11";

    development.enable = true;

    graphical.hyprland.enable = true;

    extraHomePackages = with pkgs; [
      spotify
      discord
      mpv
      ffmpeg-full
      signal-desktop
    ];
  };
}
