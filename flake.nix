{
  description = "Nix configuration";
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

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit (nixpkgs) lib; };
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
    };
}
