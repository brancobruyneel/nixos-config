{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;

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
    "Bash(git status)"
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

    # All nix commands
    "Bash(nix:*)"

    # Directory creation
    "Bash(mkdir:*)"
    "Bash(chmod:*)"

    # Search tools
    "Bash(rg:*)"
    "Bash(grep:*)"

    # System info
    "Bash(systemctl list-units:*)"
    "Bash(systemctl list-timers:*)"
    "Bash(systemctl status:*)"
    "Bash(journalctl:*)"
    "Bash(dmesg:*)"
    "Bash(env)"
    "Bash(claude --version)"
  ];

  # Autonomous profile additions - full autonomy for trusted workflows
  autonomousAllow = standardAllow ++ [
    # Git write operations
    "Bash(git commit:*)"
    "Bash(git checkout:*)"
    "Bash(git switch:*)"
    "Bash(git stash:*)"
    "Bash(git restore:*)"
    "Bash(git reset:*)"

    # File operations
    "Bash(rm:*)"
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
    # Always confirm pushing
    "Bash(git push:*)"
    "Bash(git merge:*)"
    "Bash(git rebase:*)"

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

  # Never allowed - dangerous operations
  denyList = [
    "Bash(rm -rf /*)"
    "Bash(rm -rf /)"
    "Bash(dd:*)"
    "Bash(mkfs:*)"
  ];
in
{
  options.custom.ai.claude-code.permissionProfile = mkOption {
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

  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = {
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
            standardAsk ++ standardAllow; # Conservative: ask for everything standard allows

        deny = denyList;

        defaultMode = if cfg.permissionProfile == "autonomous" then "acceptEdits" else "default";
      };
    };
  };
}
