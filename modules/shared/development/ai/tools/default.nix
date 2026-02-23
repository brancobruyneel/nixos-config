{ lib }:
let
  inherit (lib) mapAttrsToList concatStringsSep;
  inherit (builtins) readFile;

  # Convert an attribute set to YAML frontmatter
  toYamlFrontmatter =
    attrs:
    let
      formatValue =
        v:
        if builtins.isList v then
          "\n" + concatStringsSep "\n" (map (x: "  - ${x}") v)
        else if builtins.isBool v then
          if v then "true" else "false"
        else
          toString v;

      lines = mapAttrsToList (k: v: "${k}: ${formatValue v}") attrs;
    in
    "---\n${concatStringsSep "\n" lines}\n---\n";

  # Read markdown file and prepend YAML frontmatter from Nix attrs
  mkMarkdownWithFrontmatter =
    frontmatter: mdFile: (toYamlFrontmatter frontmatter) + "\n" + (readFile mdFile);

  # Import agent and command definitions
  agents = import ./agents.nix { inherit lib; };
  commands = import ./commands.nix { inherit lib; };

  # Base instructions shared by all agents
  baseInstructions = readFile ./base.md;

  # Build Claude Code agent format
  mkClaudeAgent = name: agent: {
    inherit name;
    inherit (agent) description model;
    allowedTools = agent.allowed-tools;
    customInstructions = baseInstructions + "\n\n" + (readFile agent.instructionsFile);
  };

  # Build Claude Code command format
  mkClaudeCommand = name: cmd: {
    inherit name;
    inherit (cmd) description model;
    allowedTools = cmd.allowed-tools;
    argumentHint = cmd.argument-hint or "";
    customInstructions = readFile cmd.instructionsFile;
  };

  # Merge helper for extending agents
  mergeAgents =
    base: override:
    base
    // override
    // {
      allowed-tools = (base.allowed-tools or [ ]) ++ (override.allowed-tools or [ ]);
    };

  # Merge helper for extending commands
  mergeCommands =
    base: override:
    base
    // override
    // {
      allowed-tools = (base.allowed-tools or [ ]) ++ (override.allowed-tools or [ ]);
    };

in
{
  inherit mergeAgents mergeCommands baseInstructions;

  # Raw definitions for extending
  raw = {
    inherit agents commands;
  };

  # Claude Code formatted output
  claudeCode = {
    agents = builtins.mapAttrs mkClaudeAgent agents;
    commands = builtins.mapAttrs mkClaudeCommand commands;
  };

  # OpenCode formatted output (similar structure, can be customized)
  opencode = {
    agents = builtins.mapAttrs mkClaudeAgent agents;
    commands = builtins.mapAttrs mkClaudeCommand commands;
  };

  # Skills as readable files (for memory/context injection)
  skills = {
    commit-messages = readFile ./skills/commit-messages/SKILL.md;
    writing-nix = readFile ./skills/writing-nix/SKILL.md;
    git-workflows = readFile ./skills/git-workflows/SKILL.md;
  };
}
