{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  ai-tools = import ../tools { inherit lib; };
in
{
  options.custom.ai.opencode = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.ai.opencode.enable {
    home-manager.users.${config.custom.user} = {
      home.packages = [ inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.opencode ];

      # OpenCode configuration can use ai-tools.opencode for agents/commands
      # when OpenCode supports similar configuration options
    };
  };
}
