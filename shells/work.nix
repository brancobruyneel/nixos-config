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
    nodejs

    # Infrastructure
    awscli2
    aws-vault
    ssm-session-manager-plugin
    opentofu
    k3d

    # Databases and messaging
    mongodb-atlas-cli
    mongosh
    mqttui
    mqttx-cli
    acli
    natscli

    # Tools
    bruno
    fioctl
    glab
  ];
}
