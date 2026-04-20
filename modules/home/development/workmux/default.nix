{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.custom.workmux;

  notifyScript = pkgs.writeShellScript "claude-notify" (
    builtins.replaceStrings
      [ "@terminalNotifier@" ]
      [ "${pkgs.terminal-notifier}/bin/terminal-notifier" ]
      (builtins.readFile ./notify.sh)
  );
in
{
  options.custom.workmux = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.workmux.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."workmux/config.yaml".source = ./config.yaml;

    # workmux status tracking + macOS notifications
    programs.claude-code.settings.hooks = {
      UserPromptSubmit = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = "workmux set-window-status working 2>/dev/null || true";
            }
          ];
        }
      ];
      PostToolUse = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = "workmux set-window-status working 2>/dev/null || true";
            }
          ];
        }
      ];
      Notification = [
        {
          matcher = "permission_prompt|elicitation_dialog";
          hooks = [
            {
              type = "command";
              command = "workmux set-window-status waiting 2>/dev/null || true";
            }
          ];
        }
      ];
      Stop = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = "workmux set-window-status done 2>/dev/null || true";
            }
            {
              type = "command";
              command = "${notifyScript}";
            }
          ];
        }
      ];
    };
  };
}
