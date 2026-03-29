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
├── flake.nix                  # Entry point, defines inputs and host outputs
├── lib/                       # Helper functions (mkOpt, mkSystem, mkDarwin)
├── systems/                   # Per-host system config (hardware, services, boot)
│   ├── x86_64-linux/nixos/
│   └── aarch64-darwin/makboek/
├── homes/                     # Per-host home-manager config (packages, preferences)
│   ├── x86_64-linux/branco@nixos/
│   └── aarch64-darwin/branco@makboek/
├── modules/
│   ├── shared.nix             # Cross-platform system config (base packages, nix settings)
│   ├── nixos/                 # NixOS-specific system modules (locale, users, gc)
│   ├── darwin/                # macOS-specific system modules (homebrew, aerospace)
│   └── home/                  # Home-manager modules (shared across all hosts)
│       ├── development/       # Dev tools: zsh, git, tmux, ghostty, neovim, yazi, ai
│       ├── programs/          # User apps: firefox, zen, discord
│       └── graphical/hyprland # Hyprland config (keybinds, waybar, wofi)
├── secrets/                   # Agenix encrypted secrets
├── overlays/                  # Nixpkgs overlays
├── shells/                    # Development shells
└── media/                     # Wallpapers and other media
```

## Adding a new host

1. Create system config in `systems/<arch>/<hostname>/` (hardware, services, boot)
2. Create home config in `homes/<arch>/<user>@<hostname>/` (enable modules via `custom.<module>.enable`)
3. Add to `flake.nix` using `lib.system.mkSystem` (NixOS) or `lib.system.mkDarwin` (macOS):

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
   # NixOS
   sudo nixos-rebuild switch --flake ~/.config/nix

   # macOS
   darwin-rebuild switch --flake ~/.config/nix
   ```

## Secrets

Managed with [agenix](https://github.com/ryantm/agenix). Encrypted files live in `secrets/` and are decrypted at activation time.

## Bootstrapping a fresh NixOS install

```sh
# Boot installer, set up disks, then:
nixos-generate-config --root /mnt
git clone <repo-url> /mnt/home/<user>/.config/nix
cp /mnt/etc/nixos/hardware-configuration.nix systems/x86_64-linux/<hostname>/hardware.nix
# Create system and home configs (see "Adding a new host")
nixos-install --flake .#<hostname>
# After reboot:
sudo nixos-rebuild switch --flake ~/.config/nix
```
