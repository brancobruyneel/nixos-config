{
  config,
  lib,
  ...
}:
{
  options.custom.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";
  };

  config = lib.mkIf config.custom.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };
  };
}
