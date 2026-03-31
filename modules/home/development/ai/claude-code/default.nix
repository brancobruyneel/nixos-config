{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.custom.ai.claude-code;
  ai-tools = import ../tools { inherit lib; };

  fileSuggestionScript = pkgs.writeShellScript "claude-file-suggestion" ''
    QUERY=$(${pkgs.jq}/bin/jq -r '.query // ""')
    PROJECT_DIR="''${CLAUDE_PROJECT_DIR:-.}"
    cd "$PROJECT_DIR" || exit 1
    ${pkgs.ripgrep}/bin/rg --files --follow --hidden . 2>/dev/null \
      | sort -u \
      | ${pkgs.fzf}/bin/fzf --filter "$QUERY" \
      | head -15
  '';
in
{
  imports = [
    ./permissions.nix
  ];

  options.custom.ai.claude-code = {
    enable = mkEnableOption "Claude Code CLI tool";
    permissionProfile = mkOption {
      type = types.enum [
        "conservative"
        "standard"
        "autonomous"
      ];
      default = "standard";
      description = ''
        Permission profile for Claude Code operations:
        - conservative: Minimal permissions, most operations require confirmation
        - standard: Balanced permissions for normal development workflows
        - autonomous: Maximum autonomy for trusted environments
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;

      package = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

      inherit (ai-tools.claudeCode) agents;
      inherit (ai-tools.claudeCode) commands;

      skillsDir = ai-tools.skillsDir;
      memory.source = ai-tools.baseInstructions;

      settings = {
        editorMode = "vim";
        theme = "dark";
        effortLevel = "high";
        voiceEnabled = true;

        sandbox = {
          enabled = true;
          autoAllowBashIfSandboxed = true;
          allowUnsandboxedCommands = false;
          # Note: `:*` suffix is required to match commands with arguments
          # (see https://github.com/anthropics/claude-code/issues/10524)
          excludedCommands = [
            # Go binaries; sandbox-exec blocks macOS Keychain for TLS cert verification
            "go:*"
            "golangci-lint:*"
            "gotestsum:*"
            "go-task:*"
            "opentofu:*"
            "gh:*"
            "glab:*"
            # Git needs network access for push/pull (SSH, credential helpers)
            "git:*"
            "acli:*"
            # Accesses macOS Keychain for AWS credential storage
            "aws-vault:*"
            # Read/write paths outside project directory (nix store, profiles)
            "nix:*"
            "nix-build:*"
            "nix-shell:*"
            "nix-instantiate:*"
            "nixos-rebuild:*"
            "home-manager:*"
            "darwin-rebuild:*"
          ];
          filesystem = {
            allowWrite = [
              "."
              "~/.config/glab-cli"
            ];
            denyRead = [
              ".env"
              ".env.local"
              ".env.development"
              ".env.production"
              ".env.staging"
              ".env.test"
              "/etc/shadow"
              "/etc/gshadow"
            ];
          };
          network = {
            allowedDomains = [
              "*"
            ];
          };
        };

        env = {
          CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
        };

        attribution = {
          commit = "";
          pr = "";
        };

        enabledPlugins = {
          "gopls-lsp@claude-plugins-official" = true;
          "typescript-lsp@claude-plugins-official" = true;
          "daikin@daikin-onecta-ai-tooling-marketplace" = true;
        };

        extraKnownMarketplaces = {
          daikin-onecta-ai-tooling-marketplace = {
            source = {
              source = "directory";
              path = "/Users/branco/work/daikin-edc-electrics/projects/cloud-projects/onecta/enabling/daikin-onecta-ai-tooling";
            };
          };
          claude-code-plugins = {
            source = {
              source = "github";
              repo = "anthropics/claude-code";
            };
          };
          claude-plugins-official = {
            source = {
              source = "git";
              url = "https://github.com/anthropics/claude-plugins-official.git";
            };
          };
        };

        fileSuggestion = {
          type = "command";
          command = "${fileSuggestionScript}";
        };

        statusLine = {
          type = "command";
          command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
          padding = 0;
        };
      };
    };
  };
}
