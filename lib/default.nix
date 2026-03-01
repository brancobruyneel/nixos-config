{ lib }:
{
  module = import ./module.nix { inherit lib; };
  system = import ./system;
}
