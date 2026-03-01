{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.custom.ai.opencode = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.ai.opencode.enable {
    home.packages = [ inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.opencode ];
  };
}
