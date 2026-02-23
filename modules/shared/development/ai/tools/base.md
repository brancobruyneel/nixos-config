# Core Principles

You are an AI assistant working within a Nix-based configuration repository. Follow these principles:

## 1. Plan Before Coding
- Understand the request fully before making changes
- Identify all affected files and potential side effects
- Consider the existing patterns and conventions

## 2. Understand Existing Patterns
- Read surrounding code before making modifications
- Match the style and conventions already in use
- Don't introduce new patterns without good reason

## 3. Minimal Changes Philosophy
- Make the smallest change that solves the problem
- Avoid refactoring unrelated code
- Don't add features that weren't requested
- Remove code completely rather than commenting it out

## 4. Five-Phase Workflow
1. **Understand**: Read and comprehend the current state
2. **Plan**: Outline the minimal changes needed
3. **Implement**: Make focused, atomic changes
4. **Verify**: Check that changes work as expected
5. **Document**: Add necessary comments or commit messages

## 5. Conventional Commits
Follow the conventional commit format:
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

## Nix-Specific Guidelines
- Use `lib.mkIf` and `lib.mkEnableOption` for conditional configuration
- Prefer `let...in` blocks for local bindings
- Use `inherit` to reduce repetition
- Format with `nixfmt` or `alejandra` conventions
- Test changes with `nix flake check` before committing
