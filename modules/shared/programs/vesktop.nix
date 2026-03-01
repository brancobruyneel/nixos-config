# https://gitlab.com/fazzi/nixohess/-/blob/main/home/modules/apps/discord/default.nix?ref_type=heads#L121

{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.custom.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.custom.discord.enable {
    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          discord
        ];
      };
  };
}
