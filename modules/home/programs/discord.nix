{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.discord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.custom.discord.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
