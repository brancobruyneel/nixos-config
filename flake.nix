{
  description = "Nix configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
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
        in
        {
          go = import ./shells/go.nix { inherit pkgs; };
          work = import ./shells/work.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
        }
      );
    };
}
