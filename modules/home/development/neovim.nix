{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nvim.homeModule
  ];

  options.custom.neovim = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.neovim.enable {
    nvim = {
      enable = true;
    };
  };
}
