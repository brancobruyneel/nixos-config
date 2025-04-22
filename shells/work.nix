{
  pkgs,
  lib,
  inputs,
  system,
  ...
}:
pkgs.devshell.mkShell {
  name = "Work shell";
  packages = with pkgs; [
    glab
    go
    golangci-lint
    delve
  ];
}
