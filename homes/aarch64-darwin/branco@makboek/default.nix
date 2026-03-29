{
  pkgs,
  tfpkg,
  ...
}:
{
  custom = {
    firefox.enable = true;
    zen.enable = true;
    git.includeWork = true;
  };

  home.packages = with pkgs; [
    _1password-cli
    air
    agenix-cli
    aws-vault
    awscli2
    ssm-session-manager-plugin
    devenv
    colima
    delve
    discord
    docker
    docker-compose
    ffmpeg
    fioctl
    glab
    go
    golangci-lint
    gopls
    gofumpt
    go-task
    gotestsum
    keycastr
    mqttui
    mqttx-cli
    obsidian
    acli
    natscli
    tfpkg.terraform
    bruno
    mongodb-atlas-cli
    mongosh
    mongodb-compass
    nodejs
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    k3d
  ];
}
