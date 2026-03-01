{
  config,
  osConfig,
  lib,
  ...
}:
{
  imports = [
    ./claude-code
    ./opencode
  ];

  options.custom.ai = {
    enable = lib.mkOption {
      default = true;
      example = false;
    };
  };

  config = lib.mkIf config.custom.ai.enable {
    custom.ai = {
      claude-code.enable = lib.mkDefault true;
      opencode.enable = lib.mkDefault true;
    };

    programs.zsh.sessionVariables = lib.mkIf (osConfig.age.secrets ? trellis-api-key) {
      TRELLIS_API_KEY = "$(cat ${osConfig.age.secrets.trellis-api-key.path})";
    };
  };
}
