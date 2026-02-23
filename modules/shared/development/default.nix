{
  config,
  lib,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./yazi.nix
    ./neovim.nix
    ./tmux
    ./ghostty.nix
    ./ai
  ];

  options.custom.development = {
    enable = lib.mkOption {
      default = true;
      example = false;
    };
  };

  config =
    let
      enabled = lib.mkDefault true;
    in
    {
      custom = {
        zsh.enable = enabled;
        git.enable = enabled;
        yazi.enable = enabled;
        tmux.enable = enabled;
        ghostty.enable = enabled;
        neovim.enable = enabled;
        ai.enable = enabled;
      };
    };
}
