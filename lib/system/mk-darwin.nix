{
  inputs,
  system,
  hostname,
  username,
}:
let
  inherit (inputs)
    nix-darwin
    home-manager
    agenix
    nur
    nix-homebrew
    ;

  modulesDir = ../../modules;
  systemsDir = ../../systems;
  homesDir = ../../homes;
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    {
      nixpkgs.overlays = [
        agenix.overlays.default
        nur.overlays.default
        (import ../../overlays)
      ];
    }
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    agenix.darwinModules.default
    (modulesDir + "/shared.nix")
    (modulesDir + "/darwin")
    (systemsDir + "/${system}/${hostname}")
    {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs; };
        users.${username} = {
          imports = [
            (modulesDir + "/home")
            (homesDir + "/${system}/${username}@${hostname}")
          ];
        };
      };
    }
  ];
}
