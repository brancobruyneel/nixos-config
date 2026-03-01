{ lib }:
let
  inherit (builtins) readFile;

  # Import agent and command definitions
  agents = import ./agents.nix { inherit lib; };
  commands = import ./commands.nix { inherit lib; };

  # Claude Code expects YAML frontmatter with: name, description, tools (comma-sep), model
  renderAgentFrontmatter = agent: ''
    ---
    name: ${agent.name}
    description: ${agent.description}
    tools: ${lib.concatStringsSep ", " agent.allowed-tools}
    model: ${agent.model}
    ---
  '';

  renderAgent = name: agent: ''
    ${lib.trim (renderAgentFrontmatter (agent // { inherit name; }))}

    ${lib.trim (readFile ./base.md)}

    ${lib.trim (readFile agent.instructionsFile)}
  '';

  # Claude Code expects YAML frontmatter with: allowed-tools, argument-hint, description, model
  renderCommandFrontmatter = cmd: ''
    ---
    ${lib.optionalString (cmd.allowed-tools != [ ]) "allowed-tools: ${lib.concatStringsSep ", " cmd.allowed-tools}"}
    ${lib.optionalString (cmd ? argument-hint) "argument-hint: ${cmd.argument-hint}"}
    ${lib.optionalString (cmd ? description) "description: ${cmd.description}"}
    model: ${cmd.model}
    ---
  '';

  renderCommand = _name: cmd: ''
    ${lib.trim (renderCommandFrontmatter cmd)}

    ${lib.trim (readFile cmd.instructionsFile)}
  '';

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
  inherit mergeAgents mergeCommands;

  # Raw definitions for extending
  raw = {
    inherit agents commands;
  };

  # Claude Code formatted output (markdown with YAML frontmatter)
  claudeCode = {
    agents = builtins.mapAttrs renderAgent agents;
    commands = builtins.mapAttrs renderCommand commands;
  };

  # Skills directory path (for skillsDir option)
  skillsDir = ./skills;

  # Base instructions file path (for memory.source option)
  baseInstructions = ./base.md;
}
