# Conventional Commit Messages

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

| Type | Description |
|------|-------------|
| `feat` | New feature for the user |
| `fix` | Bug fix for the user |
| `docs` | Documentation changes only |
| `style` | Formatting, whitespace (no code change) |
| `refactor` | Code restructuring (no behavior change) |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `build` | Build system or dependencies |
| `ci` | CI configuration changes |
| `chore` | Maintenance, tooling, etc. |
| `revert` | Reverting a previous commit |

## Rules

### Subject Line
- Use imperative mood: "add" not "added" or "adds"
- Capitalize first letter after colon
- No period at the end
- Max 50 characters (72 absolute max)

### Scope
- Optional, in parentheses
- Noun describing section of codebase
- Examples: `(auth)`, `(api)`, `(ui)`, `(flake)`

### Body
- Explain **why**, not **what** (code shows what)
- Wrap at 72 characters
- Separate from subject with blank line

### Footer
- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Closes #123`, `Fixes #456`

## Examples

### Simple Feature
```
feat(auth): add OAuth2 login support
```

### Bug Fix with Body
```
fix(api): handle null response from external service

The payment gateway occasionally returns null instead of
an error object when the service is degraded. This caused
unhandled exceptions in the response parser.
```

### Breaking Change
```
feat(config): change default timeout to 30 seconds

BREAKING CHANGE: Default timeout increased from 10s to 30s.
Users relying on the 10s default should explicitly set it.
```

### Chore
```
chore(deps): update flake inputs to latest
```

### Revert
```
revert: feat(auth): add OAuth2 login support

This reverts commit abc1234.
OAuth integration needs more testing before release.
```

## Nix-Specific Scopes

For Nix configuration repositories:
- `flake` - flake.nix, flake.lock changes
- `darwin` - nix-darwin specific
- `nixos` - NixOS specific
- `home` - Home Manager specific
- `<module>` - Specific module name (e.g., `git`, `zsh`, `neovim`)
