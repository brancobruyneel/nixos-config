{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "work";
  packages = with pkgs; [
    # Go
    go
    air
    delve
    gofumpt
    golangci-lint
    gopls
    go-task
    gotestsum

    # JavaScript
    biome
    nodejs

    # Infrastructure
    awscli2
    aws-vault
    ssm-session-manager-plugin
    opentofu
    k3d

    # Tools
    bruno
    fioctl
  ];
}
