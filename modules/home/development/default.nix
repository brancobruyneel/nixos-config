{
  config,
  lib,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./ssh.nix
    ./yazi.nix
    ./neovim.nix
    ./tmux
    ./ghostty.nix
    ./ai
    ./workmux
  ];

  options.custom.development = {
    enable = lib.mkOption {
      default = true;
      example = false;
    };
  };

  config = lib.mkIf config.custom.development.enable {
    custom = {
      zsh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      ghostty.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      ai.enable = lib.mkDefault true;
      workmux.enable = lib.mkDefault true;
    };
  };
}
