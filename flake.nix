{
  description = "Nix configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-terraform152.url = "github:NixOS/nixpkgs/5a8650469a9f8a1958ff9373bd27fb8e54c4365d";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    nvim.url = "github:brancobruyneel/nvim";

    nix-ai-tools.url = "github:numtide/nix-ai-tools";
    workmux.url = "github:raine/workmux";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    claude-plugins-official = {
      url = "github:anthropics/claude-plugins-official";
      flake = false;
    };
    claude-plugin-itp-general = {
      url = "git+ssh://git@git.inthepocket.org/inthepocket/skills/general.git";
      flake = false;
    };
    claude-plugin-itp-engineering = {
      url = "git+ssh://git@git.inthepocket.org/inthepocket/skills/engineering/engineering.git";
      flake = false;
    };
    claude-plugin-itp-engineering-backend = {
      url = "git+ssh://git@git.inthepocket.org/inthepocket/skills/engineering/backend.git";
      flake = false;
    };
    claude-plugin-itp-engineering-daikin = {
      url = "git+ssh://git@git.inthepocket.org/inthepocket/skills/engineering/daikin.git";
      flake = false;
    };
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit (nixpkgs) lib; };
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      nixosConfigurations.nixos = lib.system.mkSystem {
        inherit inputs;
        system = "x86_64-linux";
        hostname = "nixos";
        username = "branco";
      };

      darwinConfigurations.makboek = lib.system.mkDarwin {
        inherit inputs;
        system = "aarch64-darwin";
        hostname = "makboek";
        username = "branco";
      };

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pkgs-terraform152 = import inputs.nixpkgs-terraform152 {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          go = import ./shells/go.nix { inherit pkgs; };
          work = import ./shells/work.nix { inherit pkgs pkgs-terraform152; };
          rust = import ./shells/rust.nix { inherit pkgs; };
        }
      );
    };
}
