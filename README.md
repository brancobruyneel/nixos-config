# Nix Configuration

Declarative system configuration for NixOS and macOS using flakes, home-manager, and nix-darwin.

## Hosts

| Host | Platform | Description |
|------|----------|-------------|
| `nixos` | x86_64-linux | Desktop workstation (Hyprland, Nvidia) |
| `makboek` | aarch64-darwin | MacBook (Aerospace, Homebrew) |

## Structure

```
.
├── flake.nix                  # Entry point — defines inputs and host outputs
├── lib/                       # Helper functions
│   ├── module.nix             # Option helpers (mkOpt, mkBoolOpt, enabled/disabled)
│   └── system/
│       ├── mk-system.nix      # NixOS system builder
│       └── mk-darwin.nix      # macOS system builder
├── systems/                   # Per-host system configuration (hardware, services, boot)
│   ├── x86_64-linux/nixos/
│   └── aarch64-darwin/makboek/
├── homes/                     # Per-host home-manager configuration (packages, preferences)
│   ├── x86_64-linux/branco@nixos/
│   └── aarch64-darwin/branco@makboek/
├── modules/
│   ├── shared.nix             # Cross-platform system config (base packages, nix settings)
│   ├── nixos/                 # NixOS-specific system modules (locale, users, gc)
│   │   └── graphical/hyprland # System-level Hyprland config
│   ├── darwin/                # macOS-specific system modules (homebrew, aerospace)
│   │   └── graphical/         # Aerospace window manager
│   └── home/                  # Home-manager modules (shared across all hosts)
│       ├── development/       # Dev tools: zsh, git, tmux, ghostty, neovim, yazi, ai
│       ├── programs/          # User apps: firefox, zen, discord
│       └── graphical/hyprland # User-level Hyprland config (keybinds, waybar, wofi)
├── secrets/                   # Agenix encrypted secrets
├── overlays/                  # Nixpkgs overlays
├── shells/                    # Development shells
└── media/                     # Wallpapers and other media
```

### How it fits together

```
flake.nix
  └── lib.system.mkSystem / mkDarwin
        ├── modules/shared.nix          # base system config (both platforms)
        ├── modules/nixos/ or darwin/   # platform-specific system config
        ├── systems/{arch}/{hostname}/  # host-specific system config
        └── home-manager
              ├── modules/home/         # shared home modules (all hosts)
              └── homes/{arch}/{user}@{host}/  # host-specific home config
```

**System modules** (`modules/shared.nix`, `modules/nixos/`, `modules/darwin/`) handle system-level concerns: packages, services, users, nix settings.

**Home modules** (`modules/home/`) are proper home-manager modules that configure user-level programs. They use `mkEnableOption`/`mkIf` so each tool can be toggled.

**Host configs** (`systems/`, `homes/`) contain only what's unique to each machine — hardware, enabled features, host-specific packages.

## Adding a new host

### NixOS

1. Create the system config:

   ```
   systems/x86_64-linux/<hostname>/default.nix    # hardware, services, boot
   systems/x86_64-linux/<hostname>/hardware.nix    # from nixos-generate-config
   ```

2. Create the home config:

   ```
   homes/x86_64-linux/<username>@<hostname>/default.nix
   ```

   Enable the modules you want:

   ```nix
   { pkgs, ... }:
   {
     custom = {
       firefox.enable = true;
       zen.enable = true;
       discord.enable = true;
     };

     home.packages = with pkgs; [ ... ];
   }
   ```

3. Add the host to `flake.nix`:

   ```nix
   nixosConfigurations.<hostname> = lib.system.mkSystem {
     inherit inputs;
     system = "x86_64-linux";
     hostname = "<hostname>";
     username = "<username>";
   };
   ```

4. Build and switch:

   ```sh
   sudo nixos-rebuild switch --flake ~/.config/nix
   ```

### macOS

1. Create the system and home configs under `systems/aarch64-darwin/<hostname>/` and `homes/aarch64-darwin/<username>@<hostname>/`.

2. Add to `flake.nix` using `lib.system.mkDarwin`.

3. Build and switch:

   ```sh
   darwin-rebuild switch --flake ~/.config/nix
   ```

## Available module options

Development tools are enabled by default via `custom.development.enable = true`:

| Module | Option | Default |
|--------|--------|---------|
| Zsh | `custom.zsh.enable` | `true` |
| Git | `custom.git.enable` | `true` |
| Neovim | `custom.neovim.enable` | `true` |
| Tmux | `custom.tmux.enable` | `true` |
| Ghostty | `custom.ghostty.enable` | `true` |
| Yazi | `custom.yazi.enable` | `true` |
| AI tools | `custom.ai.enable` | `true` |

Programs must be explicitly enabled per host:

| Module | Option | Default |
|--------|--------|---------|
| Firefox | `custom.firefox.enable` | `false` |
| Zen Browser | `custom.zen.enable` | `false` |
| Discord | `custom.discord.enable` | `false` |

## Secrets

Secrets are managed with [agenix](https://github.com/ryantm/agenix). Encrypted files live in `secrets/` and are decrypted at activation time. Secret declarations live in the host's system config (`systems/`).

## Bootstrapping a fresh NixOS install

```sh
# 1. Boot the NixOS installer and set up disks/partitions

# 2. Generate hardware config
nixos-generate-config --root /mnt

# 3. Clone this repo
git clone <repo-url> /mnt/home/<user>/.config/nix
cd /mnt/home/<user>/.config/nix

# 4. Copy the generated hardware config
cp /mnt/etc/nixos/hardware-configuration.nix systems/x86_64-linux/<hostname>/hardware.nix

# 5. Create the system and home configs (see "Adding a new host" above)

# 6. Install
nixos-install --flake .#<hostname>

# 7. Reboot, then switch to home-manager managed config
sudo nixos-rebuild switch --flake ~/.config/nix
```
