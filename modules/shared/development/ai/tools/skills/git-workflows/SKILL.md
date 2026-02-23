# Git Workflows

## Branch Strategy

### Main Branches
- `main` / `master` - Production-ready code
- `develop` - Integration branch (optional)

### Feature Branches
```bash
# Create feature branch
git checkout -b feat/add-new-module

# Work, commit, push
git add .
git commit -m "feat(module): add initial structure"
git push -u origin feat/add-new-module
```

### Naming Convention
```
feat/short-description
fix/issue-number-description
refactor/what-is-being-refactored
docs/what-documentation
chore/maintenance-task
```

## Commit Workflow

### Check Status
```bash
git status
git diff              # Unstaged changes
git diff --staged     # Staged changes
```

### Stage Changes
```bash
# Stage specific files
git add file1.nix file2.nix

# Stage all changes in directory
git add modules/

# Interactive staging
git add -p            # Stage by hunk
```

### Commit
```bash
# Simple commit
git commit -m "type(scope): description"

# Commit with body
git commit -m "type(scope): description" -m "Body explaining why"
```

### Amend (Last Commit Only)
```bash
# Add to last commit
git add forgotten-file.nix
git commit --amend --no-edit

# Change last commit message
git commit --amend -m "new message"
```

## Rebasing

### Interactive Rebase
```bash
# Rebase last 3 commits
git rebase -i HEAD~3

# Commands in editor:
# pick   - keep commit
# reword - change message
# edit   - stop to amend
# squash - combine with previous
# fixup  - combine, discard message
# drop   - remove commit
```

### Rebase on Main
```bash
git fetch origin
git rebase origin/main

# If conflicts:
# 1. Fix conflicts
# 2. git add <fixed-files>
# 3. git rebase --continue
```

## Stashing

```bash
# Stash current changes
git stash

# Stash with message
git stash push -m "WIP: feature description"

# List stashes
git stash list

# Apply and remove
git stash pop

# Apply and keep
git stash apply

# Apply specific stash
git stash apply stash@{2}
```

## Undoing Changes

### Unstaged Changes
```bash
# Discard changes to file
git checkout -- file.nix

# Discard all unstaged changes
git checkout -- .
```

### Staged Changes
```bash
# Unstage file
git reset HEAD file.nix

# Unstage all
git reset HEAD
```

### Commits
```bash
# Undo last commit, keep changes staged
git reset --soft HEAD~1

# Undo last commit, keep changes unstaged
git reset HEAD~1

# Undo last commit, discard changes
git reset --hard HEAD~1
```

### Revert (Safe for Shared History)
```bash
# Create new commit that undoes changes
git revert <commit-hash>
```

## Viewing History

```bash
# Compact log
git log --oneline -10

# With graph
git log --oneline --graph --all

# Show specific commit
git show <commit-hash>

# Show changes in commit
git show --stat <commit-hash>
```

## Remote Operations

```bash
# Fetch updates
git fetch origin

# Pull with rebase
git pull --rebase origin main

# Push
git push origin branch-name

# Push and set upstream
git push -u origin branch-name

# Force push (after rebase, BE CAREFUL)
git push --force-with-lease
```

## Best Practices

1. **Commit early, commit often** - Small, focused commits
2. **Write good messages** - Future you will thank you
3. **Rebase before merge** - Clean linear history
4. **Never force push main** - Only your feature branches
5. **Use `--force-with-lease`** - Safer than `--force`
6. **Review before commit** - `git diff --staged`
