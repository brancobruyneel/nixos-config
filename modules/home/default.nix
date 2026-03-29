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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
