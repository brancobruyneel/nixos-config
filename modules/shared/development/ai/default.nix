{
  config,
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

  config =
    let
      enabled = lib.mkDefault true;
    in
    {
      age.secrets.trellis-api-key = {
        file = ../../../../secrets/keys/trellis-api.age;
        mode = "400";
        owner = config.custom.user;
      };

      home-manager.users.${config.custom.user} = {
        programs.zsh.sessionVariables = {
          TRELLIS_API_KEY = "$(cat ${config.age.secrets.trellis-api-key.path})";
        };
      };

      custom.ai = {
        claude-code.enable = enabled;
        opencode.enable = enabled;
      };
    };
}
