# Writing Nix

## Language Basics

### Let Bindings
```nix
let
  name = "value";
  list = [ 1 2 3 ];
  set = { a = 1; b = 2; };
in
# use name, list, set here
```

### Functions
```nix
# Single argument
f = x: x + 1

# Multiple arguments (curried)
add = a: b: a + b

# Attribute set argument
greet = { name, greeting ? "Hello" }: "${greeting}, ${name}!"

# With @-pattern
f = args@{ a, b, ... }: a + b + args.c
```

### Inherit
```nix
# Inherit from scope
let
  a = 1;
  b = 2;
in {
  inherit a b;  # Same as: a = a; b = b;
}

# Inherit from set
let
  src = { x = 1; y = 2; };
in {
  inherit (src) x y;  # Same as: x = src.x; y = src.y;
}
```

## Module System

### Basic Module Structure
```nix
{ config, lib, pkgs, ... }:
{
  options.myModule = {
    enable = lib.mkEnableOption "my module";

    setting = lib.mkOption {
      type = lib.types.str;
      default = "value";
      description = "A setting";
    };
  };

  config = lib.mkIf config.myModule.enable {
    # Configuration when enabled
  };
}
```

### Option Types
```nix
lib.types.bool
lib.types.str
lib.types.int
lib.types.path
lib.types.package
lib.types.listOf lib.types.str
lib.types.attrsOf lib.types.int
lib.types.nullOr lib.types.str
lib.types.enum [ "a" "b" "c" ]
lib.types.submodule { options = { ... }; }
```

### Conditional Configuration
```nix
# mkIf - conditional config
config = lib.mkIf cfg.enable {
  programs.git.enable = true;
};

# mkMerge - combine multiple configs
config = lib.mkMerge [
  { always = true; }
  (lib.mkIf cfg.enable { enabled = true; })
];

# mkOverride - set priority
programs.git.enable = lib.mkOverride 100 true;

# mkForce - highest priority (50)
programs.git.enable = lib.mkForce true;

# mkDefault - lowest priority (1000)
programs.git.enable = lib.mkDefault true;
```

## Flake Structure

```nix
{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # NixOS configurations
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };

    # Darwin configurations
    darwinConfigurations.hostname = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin.nix ];
    };

    # Packages
    packages.x86_64-linux.default = pkgs.hello;
  };
}
```

## Common Patterns

### Overlay
```nix
final: prev: {
  myPackage = prev.myPackage.overrideAttrs (old: {
    version = "2.0";
  });
}
```

### Override
```nix
# Override derivation attributes
pkgs.hello.overrideAttrs (old: {
  pname = "hello-custom";
})

# Override function arguments
pkgs.hello.override {
  stdenv = pkgs.clangStdenv;
}
```

### Import with Arguments
```nix
import ./module.nix {
  inherit lib pkgs;
  custom = "value";
}
```

## Best Practices

1. **Use `lib.mkIf`** for conditional configuration
2. **Use `inherit`** to reduce repetition
3. **Prefer `let...in`** for local bindings
4. **Use `//`** for attribute set merging
5. **Document options** with `description`
6. **Set sensible defaults** with `default`
7. **Use appropriate types** for validation
