{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.ai.claude-code;

  # Base safe operations - always allowed regardless of profile
  baseAllow = [
    # Core Claude Code tools
    "Glob(*)"
    "Grep(*)"
    "LS(*)"
    "Read(*)"
    "Search(*)"
    "Task(*)"
    "TodoWrite(*)"

    # Safe read-only git commands
    "Bash(git status:*)"
    "Bash(git log:*)"
    "Bash(git diff:*)"
    "Bash(git show:*)"
    "Bash(git branch:*)"
    "Bash(git remote:*)"

    # Safe file system operations
    "Bash(ls:*)"
    "Bash(find:*)"
    "Bash(cat:*)"
    "Bash(head:*)"
    "Bash(tail:*)"

    # Safe nix read operations
    "Bash(nix eval:*)"
    "Bash(nix flake show:*)"
    "Bash(nix flake metadata:*)"

    # Trusted web domains
    "WebFetch(domain:github.com)"
    "WebFetch(domain:raw.githubusercontent.com)"
  ];

  # Standard profile additions - balanced permissions
  standardAllow = baseAllow ++ [
    # Git staging
    "Bash(git add:*)"

    # Safe nix commands (read-only / build)
    "Bash(nix build:*)"
    "Bash(nix flake check:*)"
    "Bash(nix flake lock:*)"
    "Bash(nix flake update:*)"
    "Bash(nix search:*)"

    # Directory creation and file utilities
    "Bash(mkdir:*)"
    "Bash(chmod:*)"
    "Bash(wc:*)"
    "Bash(xargs:*)"
    "Bash(zip:*)"
    "Bash(unzip:*)"

    # Search tools
    "Bash(rg:*)"
    "Bash(grep:*)"

    # Common development tools (safe inside sandbox)
    "Bash(npm:*)"
    "Bash(npx:*)"
    "Bash(node:*)"
    "Bash(go:*)"
    "Bash(python3:*)"
    "Bash(terraform plan:*)"
    "Bash(terraform fmt:*)"
    "Bash(terraform validate:*)"
    "Bash(terraform init:*)"

    # System info
    "Bash(systemctl list-units:*)"
    "Bash(systemctl list-timers:*)"
    "Bash(systemctl status:*)"
    "Bash(journalctl:*)"
    "Bash(dmesg:*)"
    "Bash(env)"
    "Bash(claude --version)"

    # Daikin skills
    "Skill(daikin:*)"

    # Datadog MCP - read/search operations
    "mcp__plugin_daikin_datadog__analyze_datadog_logs"
    "mcp__plugin_daikin_datadog__get_*"
    "mcp__plugin_daikin_datadog__search_*"

    # Incident.io MCP - read/list/get operations
    "mcp__plugin_daikin_incidentio__get_*"
    "mcp__plugin_daikin_incidentio__list_*"
    "mcp__plugin_daikin_incidentio__search_*"

    # Slack MCP - read/search operations
    "mcp__claude_ai_Slack__slack_read_*"
    "mcp__claude_ai_Slack__slack_search_*"

    # Web access
    "WebFetch(domain:gitlab.com)"
    "WebFetch(domain:docs.datadoghq.com)"
    "WebSearch"
  ];

  # Autonomous profile additions - full autonomy for trusted workflows
  autonomousAllow = standardAllow ++ [
    # Git write operations
    "Bash(git commit:*)"
    "Bash(git checkout:*)"
    "Bash(git switch:*)"
    "Bash(git stash:*)"
    "Bash(git restore:*)"
  ];

  # Operations requiring confirmation in non-autonomous mode
  standardAsk = [
    # Potentially destructive git commands
    "Bash(git checkout:*)"
    "Bash(git commit:*)"
    "Bash(git merge:*)"
    "Bash(git pull:*)"
    "Bash(git push:*)"
    "Bash(git rebase:*)"
    "Bash(git reset:*)"
    "Bash(git restore:*)"
    "Bash(git stash:*)"
    "Bash(git switch:*)"

    # File deletion and modification
    "Bash(cp:*)"
    "Bash(mv:*)"
    "Bash(rm:*)"

    # Nix commands that can execute arbitrary code (excluded from sandbox)
    "Bash(nix shell:*)"
    "Bash(nix develop:*)"
    "Bash(nix run:*)"
    "Bash(nix-shell:*)"
    "Bash(nix-build:*)"

    # CLI tools that hit external APIs (excluded from sandbox)
    "Bash(glab:*)"
    "Bash(acli:*)"
    "Bash(aws-vault:*)"

    # Terraform mutations
    "Bash(terraform apply:*)"
    "Bash(terraform destroy:*)"
    "Bash(terraform import:*)"

    # Datadog MCP - mutating operations
    "mcp__plugin_daikin_datadog__create_datadog_notebook"
    "mcp__plugin_daikin_datadog__edit_datadog_notebook"

    # Incident.io MCP - mutating operations
    "mcp__plugin_daikin_incidentio__assign_incident_role"
    "mcp__plugin_daikin_incidentio__close_incident"
    "mcp__plugin_daikin_incidentio__create_alert_event"
    "mcp__plugin_daikin_incidentio__create_alert_route"
    "mcp__plugin_daikin_incidentio__create_custom_field"
    "mcp__plugin_daikin_incidentio__create_custom_field_option"
    "mcp__plugin_daikin_incidentio__create_incident"
    "mcp__plugin_daikin_incidentio__create_incident_smart"
    "mcp__plugin_daikin_incidentio__create_incident_update"
    "mcp__plugin_daikin_incidentio__delete_custom_field"
    "mcp__plugin_daikin_incidentio__delete_incident_update"
    "mcp__plugin_daikin_incidentio__update_alert_route"
    "mcp__plugin_daikin_incidentio__update_catalog_entry"
    "mcp__plugin_daikin_incidentio__update_custom_field"
    "mcp__plugin_daikin_incidentio__update_incident"
    "mcp__plugin_daikin_incidentio__update_workflow"

    # Slack MCP - mutating operations
    "mcp__claude_ai_Slack__slack_create_canvas"
    "mcp__claude_ai_Slack__slack_schedule_message"
    "mcp__claude_ai_Slack__slack_send_message"
    "mcp__claude_ai_Slack__slack_send_message_draft"
    "mcp__claude_ai_Slack__slack_update_canvas"

    # System control operations
    "Bash(systemctl disable:*)"
    "Bash(systemctl enable:*)"
    "Bash(systemctl mask:*)"
    "Bash(systemctl reload:*)"
    "Bash(systemctl restart:*)"
    "Bash(systemctl start:*)"
    "Bash(systemctl stop:*)"
    "Bash(systemctl unmask:*)"

    # Network operations
    "Bash(curl:*)"
    "Bash(ping:*)"
    "Bash(rsync:*)"
    "Bash(scp:*)"
    "Bash(ssh:*)"
    "Bash(wget:*)"

    # Package management
    "Bash(nixos-rebuild:*)"
    "Bash(sudo:*)"

    # Process management
    "Bash(kill:*)"
    "Bash(killall:*)"
    "Bash(pkill:*)"
  ];

  # Autonomous mode still requires confirmation for these
  autonomousAsk = [
    # Always confirm pushing and destructive git ops
    "Bash(git push:*)"
    "Bash(git merge:*)"
    "Bash(git rebase:*)"
    "Bash(git reset:*)"

    # File deletion
    "Bash(rm:*)"

    # System operations
    "Bash(systemctl:*)"
    "Bash(nixos-rebuild:*)"
    "Bash(sudo:*)"

    # Network operations
    "Bash(curl:*)"
    "Bash(rsync:*)"
    "Bash(scp:*)"
    "Bash(ssh:*)"
    "Bash(wget:*)"

    # Process management
    "Bash(kill:*)"
    "Bash(killall:*)"
    "Bash(pkill:*)"
  ];

  # Never allowed - dangerous operations and sensitive files
  denyList = [
    "Bash(rm -rf /*)"
    "Bash(rm -rf /)"
    "Bash(dd:*)"
    "Bash(mkfs:*)"

    # Prevent reading secret files
    "Read(.env)"
    "Read(.env.*)"
    "Bash(cat .env*)"
    "Bash(printenv:*)"
  ];
in
{
  config = lib.mkIf cfg.enable {
    programs.claude-code.settings.permissions = {
      allow =
        if cfg.permissionProfile == "autonomous" then
          autonomousAllow
        else if cfg.permissionProfile == "standard" then
          standardAllow
        else
          baseAllow;

      ask =
        if cfg.permissionProfile == "autonomous" then
          autonomousAsk
        else if cfg.permissionProfile == "standard" then
          standardAsk
        else
          standardAsk ++ standardAllow;

      deny = denyList;

      defaultMode = if cfg.permissionProfile == "autonomous" then "acceptEdits" else "default";
    };
  };
}
