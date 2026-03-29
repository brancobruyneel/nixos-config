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
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = {
      programs.claude-code = {
        enable = true;

        package = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

        # Agents as markdown files with YAML frontmatter
        inherit (ai-tools.claudeCode) agents;

        # Commands as markdown files with YAML frontmatter
        inherit (ai-tools.claudeCode) commands;

        # Skills directory containing SKILL.md files
        skillsDir = ai-tools.skillsDir;

        # Base instructions as CLAUDE.md
        memory.source = ai-tools.baseInstructions;

        settings = {
          editorMode = "vim";
          theme = "dark";
          effortLevel = "high";
          voiceEnabled = true;

          sandbox = {
            enabled = true;
            autoAllowBashIfSandboxed = true;
            excludedCommands = [
              "glab"
              "acli"
              "aws-vault"
            ];
            filesystem = {
              # Blanket deny, then allowlist what dev tooling needs
              denyRead = [
                "/"
              ];
              allowRead = [
                # Project directory (implicit, but explicit for clarity)
                "."

                # Nix ecosystem
                "/nix/store"
                "/nix/var"
                "/run/current-system"
                "/etc/nix"
                "~/.nix-profile"
                "~/.nix-defexpr"
                "~/.local/state/nix"

                # System binaries and libraries
                "/bin"
                "/usr/bin"
                "/usr/lib"
                "/usr/share"
                "/opt/homebrew"
                "/Library/Developer/CommandLineTools"

                # Dev tool caches and configs
                "~/.npm"
                "~/.npm-global"
                "~/go"
                "~/.terraform.d"
                "~/.cache"

                # Git
                "~/.gitconfig"

                # Claude Code
                "~/.claude"

                # Daikin projects (for worktrees and cross-repo reads)
                "~/work/daikin-edc-electrics"

                # Nix config repo
                "~/.config/nix"

                # AWS config (profiles only, NOT credentials)
                "~/.aws/config"

                # glab (excluded from sandbox, but reads config)
                "~/.config/glab-cli"
              ];
            };
            network = {
              allowedDomains = [
                "gitlab.com"
                "*.atlassian.net"
                "registry.npmjs.org"
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
  };
}
