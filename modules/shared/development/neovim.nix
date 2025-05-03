{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.custom.neovim = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };
  config = lib.mkIf config.custom.neovim.enable {
    home-manager.users.${config.custom.user} = {
      imports = [
        inputs.nvim.homeModule
      ];

      nvim = {
        enable = true;
      };
    };
  };
}
