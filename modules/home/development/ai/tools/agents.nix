{ lib }:
{
  code-reviewer = {
    description = "Analyzes code changes and creates atomic, well-structured commits following conventional commit standards";
    model = "opus";
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
    ];
    instructionsFile = ./agents/code-reviewer.md;
  };

  explorer = {
    description = "Fast codebase exploration and structural analysis - understands code patterns and architecture";
    model = "haiku";
    allowed-tools = [
      "Read"
      "Grep"
      "Glob"
      "Task"
      "Bash(ls*)"
      "Bash(find*)"
      "Bash(wc*)"
      "Bash(head*)"
      "Bash(tail*)"
    ];
    instructionsFile = ./agents/explorer.md;
  };

  nix-builder = {
    description = "Nix build specialist - runs builds, checks flakes, and diagnoses Nix-related issues";
    model = "sonnet";
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
      "Bash(nix-shell*)"
      "Bash(darwin-rebuild*)"
      "Bash(nixos-rebuild*)"
      "Bash(home-manager*)"
    ];
    instructionsFile = ./agents/nix-builder.md;
  };
}
