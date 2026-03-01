{ lib }:
{
  commit-changes = {
    description = "Analyze staged and unstaged changes, then create atomic commits with conventional commit messages";
    model = "opus";
    argument-hint = "[files or scope to focus on]";
    allowed-tools = [
      "Read"
      "Grep"
      "Glob"
      "Edit"
      "Bash(git status*)"
      "Bash(git diff*)"
      "Bash(git log*)"
      "Bash(git add*)"
      "Bash(git commit*)"
      "Bash(git show*)"
      "Bash(git rev-parse*)"
      "Bash(git restore*)"
    ];
    instructionsFile = ./commands/git/commit-changes.md;
  };

  analyze = {
    description = "Explore and analyze the codebase structure, patterns, and architecture";
    model = "haiku";
    argument-hint = "[area or question to investigate]";
    allowed-tools = [
      "Read"
      "Grep"
      "Glob"
      "Task"
      "Bash(ls*)"
      "Bash(find*)"
      "Bash(wc*)"
    ];
    instructionsFile = ./commands/project/analyze.md;
  };

  build-check = {
    description = "Run Nix builds and checks, diagnose errors, and suggest fixes";
    model = "sonnet";
    argument-hint = "[package or flake target]";
    allowed-tools = [
      "Read"
      "Grep"
      "Glob"
      "Edit"
      "Bash(nix build*)"
      "Bash(nix flake*)"
      "Bash(nix eval*)"
      "Bash(nix develop*)"
      "Bash(nix-build*)"
      "Bash(darwin-rebuild*)"
      "Bash(nixos-rebuild*)"
      "Bash(home-manager*)"
    ];
    instructionsFile = ./commands/nix/build-check.md;
  };
}
