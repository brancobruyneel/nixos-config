# /commit-changes Command

Analyze all staged and unstaged changes, then create atomic commits with well-written conventional commit messages.

## Workflow

### Step 1: Assess Current State
```bash
git status
git diff --stat
git diff --staged --stat
```

### Step 2: Review Changes in Detail
```bash
# Review unstaged changes
git diff

# Review staged changes
git diff --staged
```

### Step 3: Group Related Changes
Identify changes that belong together:
- Same feature or fix
- Same module or component
- Same type of change (all refactoring, all formatting, etc.)

### Step 4: Stage Atomically
```bash
# Stage specific files
git add path/to/file.nix

# Stage specific hunks (if needed)
git add -p path/to/file.nix
```

### Step 5: Write Commit Message
Format:
```
<type>(<scope>): <description>

[body]

[footer]
```

### Step 6: Commit and Verify
```bash
git commit -m "..."
git show --stat
```

## Commit Types

| Type | Use When |
|------|----------|
| `feat` | Adding new functionality |
| `fix` | Fixing a bug |
| `refactor` | Restructuring without behavior change |
| `docs` | Documentation only |
| `style` | Formatting, whitespace |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `build` | Build system changes |
| `ci` | CI configuration |
| `chore` | Maintenance tasks |

## Scope Guidelines

For this Nix configuration repository:
- `flake` - Changes to flake.nix or flake.lock
- `darwin` - macOS-specific configuration
- `nixos` - NixOS-specific configuration
- `home` - Home Manager configuration
- Module names: `claude-code`, `zsh`, `git`, etc.

## Example Session

```
$ git status
M  flake.nix
M  modules/shared/development/ai/claude-code/default.nix
A  modules/shared/development/ai/claude-code/permissions.nix

Analysis:
- flake.nix: Added new input
- claude-code/default.nix: Enabled new feature
- permissions.nix: New file for permissions

Commits:
1. feat(flake): add nix-ai-tools input
2. feat(claude-code): add permissions module with default allow rules
```
