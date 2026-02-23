# /build-check Command

Run Nix builds and checks, diagnose errors, and suggest fixes.

## Usage

```
/build-check                    # Run nix flake check
/build-check .#darwin           # Build specific target
/build-check --rebuild          # Run darwin-rebuild or nixos-rebuild
```

## Workflow

### Step 1: Validate Flake
```bash
nix flake check
```

### Step 2: If Check Passes, Build
```bash
# For packages
nix build .#packageName

# For system configuration
darwin-rebuild build --flake .
# or
nixos-rebuild build --flake .
```

### Step 3: If Errors, Diagnose
1. Read the full error message
2. Identify the failing component
3. Find the relevant source file
4. Determine the root cause

### Step 4: Fix and Retry
1. Make minimal fix
2. Re-run the check/build
3. Confirm success

## Common Build Targets

### System Configurations
```bash
# macOS
darwin-rebuild switch --flake .#macbook

# NixOS
nixos-rebuild switch --flake .#server

# Home Manager (standalone)
home-manager switch --flake .#user
```

### Flake Outputs
```bash
# Show all outputs
nix flake show

# Build specific output
nix build .#packages.aarch64-darwin.default
```

## Error Diagnosis Guide

### Syntax Errors
```
error: syntax error, unexpected '}'
```
- Check for missing semicolons
- Check for unbalanced brackets
- Check for missing commas in lists

### Missing Attributes
```
error: attribute 'foo' missing
```
- Verify the attribute exists in the source
- Check for typos
- Ensure inputs are correctly passed

### Type Errors
```
error: value is a string while a set was expected
```
- Check option type definitions
- Verify you're using the right syntax
- Look for `mkIf` without `mkEnableOption`

### Infinite Recursion
```
error: infinite recursion encountered
```
- Find circular dependencies
- Check for self-referential `config`
- Use `lib.mkForce` carefully

## Quick Fixes

### Update Inputs
```bash
nix flake update
# or specific input
nix flake lock --update-input nixpkgs
```

### Clear Cache
```bash
# Remove result symlink
rm -f result

# Garbage collect (careful!)
nix-collect-garbage
```

### Check Evaluation
```bash
nix eval .#darwinConfigurations.macbook.config.system.build.toplevel
```
