{ config, lib, pkgs, ... }:

{
	options.custom.zsh = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

	config = lib.mkIf config.custom.zsh.enable {
		programs.zsh = {
			enable = true;
	};
}
