{
  osConfig,
  ...
}:
{
  imports = [
    ./development
    ./graphical
    ./programs
  ];

  home.stateVersion = osConfig.custom.homeStateVersion;
  home.packages = osConfig.custom.extraHomePackages;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
