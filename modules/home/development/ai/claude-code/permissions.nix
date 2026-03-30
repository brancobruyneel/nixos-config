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
    # File editing tools (sandbox restricts write scope to allowWrite paths)
    "Edit(*)"
    "Write(*)"

    # Git operations
    "Bash(git add:*)"
    "Bash(git commit:*)"
    "Bash(git worktree:*)"

    # Safe nix commands (read-only / build)
    "Bash(nix build:*)"
    "Bash(nix flake check:*)"
    "Bash(nix flake lock:*)"
    "Bash(nix flake update:*)"
    "Bash(nix search:*)"
    "Bash(nix run nixpkgs#:*)"
    "Bash(nix shell nixpkgs#:*)"

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

    # GitHub CLI - read-only operations (mutating gh commands remain in ask list)
    "Bash(gh auth status:*)"
    "Bash(gh api:*)"
    "Bash(gh browse:*)"
    "Bash(gh issue list:*)"
    "Bash(gh issue view:*)"
    "Bash(gh issue status:*)"
    "Bash(gh pr list:*)"
    "Bash(gh pr view:*)"
    "Bash(gh pr diff:*)"
    "Bash(gh pr status:*)"
    "Bash(gh pr checks:*)"
    "Bash(gh repo view:*)"
    "Bash(gh repo list:*)"
    "Bash(gh release list:*)"
    "Bash(gh release view:*)"
    "Bash(gh run list:*)"
    "Bash(gh run view:*)"
    "Bash(gh search:*)"

    # GitLab CLI - read-only operations (mutating glab commands remain in ask list)
    "Bash(glab auth status:*)"
    "Bash(glab mr list:*)"
    "Bash(glab mr view:*)"
    "Bash(glab mr diff:*)"
    "Bash(glab mr approvers:*)"
    "Bash(glab mr issues:*)"
    "Bash(glab issue list:*)"
    "Bash(glab issue view:*)"
    "Bash(glab issue board:*)"
    "Bash(glab ci list:*)"
    "Bash(glab ci view:*)"
    "Bash(glab ci status:*)"
    "Bash(glab ci get:*)"
    "Bash(glab ci lint:*)"
    "Bash(glab ci trace:*)"
    "Bash(glab ci artifact:*)"
    "Bash(glab ci config:*)"
    "Bash(glab pipeline list:*)"
    "Bash(glab pipeline view:*)"
    "Bash(glab pipeline status:*)"
    "Bash(glab repo view:*)"
    "Bash(glab repo list:*)"
    "Bash(glab repo search:*)"
    "Bash(glab repo contributors:*)"
    "Bash(glab release list:*)"
    "Bash(glab release view:*)"
    "Bash(glab label list:*)"
    "Bash(glab variable list:*)"
    "Bash(glab config get:*)"

    # Atlassian CLI - read-only operations (mutating acli commands remain in ask list)
    "Bash(acli auth status:*)"
    "Bash(acli jira workitem view:*)"
    "Bash(acli jira workitem search:*)"
    "Bash(acli jira workitem comment list:*)"
    "Bash(acli jira workitem comment visibility:*)"
    "Bash(acli jira workitem attachment list:*)"
    "Bash(acli jira workitem link list:*)"
    "Bash(acli jira workitem link type:*)"
    "Bash(acli jira workitem watcher list:*)"
    "Bash(acli jira board search:*)"
    "Bash(acli jira board get:*)"
    "Bash(acli jira board list-projects:*)"
    "Bash(acli jira board list-sprints:*)"
    "Bash(acli jira sprint view:*)"
    "Bash(acli jira sprint list-workitems:*)"
    "Bash(acli jira project list:*)"
    "Bash(acli jira project view:*)"
    "Bash(acli jira filter get:*)"
    "Bash(acli jira filter get-columns:*)"
    "Bash(acli jira filter list:*)"
    "Bash(acli jira filter search:*)"
    "Bash(acli jira dashboard search:*)"
    "Bash(acli confluence page view:*)"
    "Bash(acli confluence space list:*)"
    "Bash(acli confluence space view:*)"
    "Bash(acli confluence blog list:*)"
    "Bash(acli confluence blog view:*)"
    "Bash(acli config:*)"

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

    # Web access - all domains (curl/wget still gated by ask list)
    # WebFetch(*) covers WebFetch tool calls; WebFetch(domain:*) covers
    # non-sandbox network access checks (MCP servers, excluded commands)
    "WebFetch(*)"
    "WebFetch(domain:*)"
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

    # GitHub CLI - mutating operations
    "Bash(gh issue create:*)"
    "Bash(gh issue close:*)"
    "Bash(gh issue reopen:*)"
    "Bash(gh issue edit:*)"
    "Bash(gh issue delete:*)"
    "Bash(gh issue comment:*)"
    "Bash(gh pr create:*)"
    "Bash(gh pr merge:*)"
    "Bash(gh pr close:*)"
    "Bash(gh pr reopen:*)"
    "Bash(gh pr edit:*)"
    "Bash(gh pr review:*)"
    "Bash(gh pr comment:*)"
    "Bash(gh release create:*)"
    "Bash(gh release delete:*)"
    "Bash(gh repo create:*)"
    "Bash(gh repo delete:*)"
    "Bash(gh repo fork:*)"
    "Bash(gh run rerun:*)"
    "Bash(gh run cancel:*)"

    # GitLab CLI - mutating operations
    "Bash(glab mr create:*)"
    "Bash(glab mr merge:*)"
    "Bash(glab mr close:*)"
    "Bash(glab mr reopen:*)"
    "Bash(glab mr update:*)"
    "Bash(glab mr approve:*)"
    "Bash(glab mr revoke:*)"
    "Bash(glab mr note:*)"
    "Bash(glab mr delete:*)"
    "Bash(glab mr for:*)"
    "Bash(glab mr rebase:*)"
    "Bash(glab mr subscribe:*)"
    "Bash(glab mr unsubscribe:*)"
    "Bash(glab mr todo:*)"
    "Bash(glab issue create:*)"
    "Bash(glab issue close:*)"
    "Bash(glab issue reopen:*)"
    "Bash(glab issue update:*)"
    "Bash(glab issue delete:*)"
    "Bash(glab issue note:*)"
    "Bash(glab issue subscribe:*)"
    "Bash(glab issue unsubscribe:*)"
    "Bash(glab ci run:*)"
    "Bash(glab ci run-trig:*)"
    "Bash(glab ci trigger:*)"
    "Bash(glab ci cancel:*)"
    "Bash(glab ci delete:*)"
    "Bash(glab ci retry:*)"
    "Bash(glab pipeline run:*)"
    "Bash(glab pipeline delete:*)"
    "Bash(glab repo create:*)"
    "Bash(glab repo delete:*)"
    "Bash(glab repo fork:*)"
    "Bash(glab repo mirror:*)"
    "Bash(glab repo transfer:*)"
    "Bash(glab repo update:*)"
    "Bash(glab release create:*)"
    "Bash(glab config set:*)"

    # Atlassian CLI - mutating operations
    "Bash(acli jira workitem create:*)"
    "Bash(acli jira workitem create-bulk:*)"
    "Bash(acli jira workitem edit:*)"
    "Bash(acli jira workitem delete:*)"
    "Bash(acli jira workitem assign:*)"
    "Bash(acli jira workitem transition:*)"
    "Bash(acli jira workitem archive:*)"
    "Bash(acli jira workitem unarchive:*)"
    "Bash(acli jira workitem clone:*)"
    "Bash(acli jira workitem comment create:*)"
    "Bash(acli jira workitem comment update:*)"
    "Bash(acli jira workitem comment delete:*)"
    "Bash(acli jira workitem attachment delete:*)"
    "Bash(acli jira workitem link create:*)"
    "Bash(acli jira workitem link delete:*)"
    "Bash(acli jira workitem watcher remove:*)"
    "Bash(acli jira board create:*)"
    "Bash(acli jira board delete:*)"
    "Bash(acli jira sprint create:*)"
    "Bash(acli jira sprint update:*)"
    "Bash(acli jira sprint delete:*)"
    "Bash(acli jira project create:*)"
    "Bash(acli jira project update:*)"
    "Bash(acli jira project delete:*)"
    "Bash(acli jira project archive:*)"
    "Bash(acli jira project restore:*)"
    "Bash(acli jira field create:*)"
    "Bash(acli jira field delete:*)"
    "Bash(acli jira field cancel-delete:*)"
    "Bash(acli jira filter update:*)"
    "Bash(acli jira filter add-favourite:*)"
    "Bash(acli jira filter change-owner:*)"
    "Bash(acli jira filter reset-columns:*)"
    "Bash(acli confluence space create:*)"
    "Bash(acli confluence space update:*)"
    "Bash(acli confluence space archive:*)"
    "Bash(acli confluence space restore:*)"
    "Bash(acli confluence blog create:*)"

    # AWS vault
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
