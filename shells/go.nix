{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "go";
  packages = with pkgs; [
    go
    air
    delve
    gofumpt
    golangci-lint
    gopls
    go-task
    gotestsum
  ];
}
