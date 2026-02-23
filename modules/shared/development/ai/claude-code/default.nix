{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.custom.ai.claude-code;
  ai-tools = import ../tools { inherit lib; };
in
{
  imports = [
    ./permissions.nix
  ];

  options.custom.ai.claude-code = {
    enable = mkEnableOption "Claude Code CLI tool";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = {
      programs.claude-code = {
        enable = true;

        package = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

        settings = {
          editorMode = "vim";
          theme = "dark";

          # AI Tools - agents and commands
          agents = ai-tools.claudeCode.agents;
          commands = ai-tools.claudeCode.commands;

          # Memory includes base instructions and skills
          memory = [
            ai-tools.baseInstructions
            ai-tools.skills.commit-messages
            ai-tools.skills.writing-nix
            ai-tools.skills.git-workflows
          ];

          # Plugins
          enabledPlugins = {
            "REDACTED@REDACTED" = true;
          };
          extraKnownMarketplaces = {
            "REDACTED" = {
              "source" = {
                "source" = "directory";
                "path" =
                  "/Users/branco/work/REDACTED/projects/cloud-projects/REDACTED/enabling/REDACTED";
              };
            };
          };

          statusLine = {
            type = "command";
            command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
            padding = 0;
          };
        };
      };
    };
  };
}
