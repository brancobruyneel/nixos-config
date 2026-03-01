{
  inputs,
  system,
  hostname,
  username,
}:
let
  inherit (inputs)
    nixpkgs
    home-manager
    agenix
    nur
    ;

  modulesDir = ../../modules;
  systemsDir = ../../systems;
  homesDir = ../../homes;
in
nixpkgs.lib.nixosSystem {
  inherit system;
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
    (modulesDir + "/shared.nix")
    (modulesDir + "/nixos")
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
