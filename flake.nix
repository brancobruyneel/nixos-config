{
  description = "A simple NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tfpkg.url = "github:NixOS/nixpkgs/3c614fbc76fc152f3e1bc4b2263da6d90adf80fb";

    flake-utils.url = "github:numtide/flake-utils";

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
  };
  outputs =
    {
      self,
      nixpkgs,
      tfpkg,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nix-ai-tools,
      agenix,
      nur,
      ...
    }@inputs:
    let
      nixosSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
    in
    {

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = nixosSystem;
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.overlays = [
                agenix.overlays.default
                nur.overlays.default
              ];
            }
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            ./machines/nixos
            ./modules/nixos
            ./modules/shared
          ];
        };
      };
      darwinConfigurations = {
        makboek = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = {
            inherit inputs;
            tfpkg = import tfpkg {
              system = darwinSystem;
            };
          };
          modules = [
            {
              nixpkgs.overlays = [
                agenix.overlays.default
                nur.overlays.default
                (import ./overlays)
              ];
            }
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            agenix.darwinModules.default
            ./modules/darwin
            ./modules/shared
            ./machines/makboek
          ];
        };
      };
    };
}
