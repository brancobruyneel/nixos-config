{
  pkgs,
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
    agenix-cli
    colima
    discord
    docker
    docker-compose
    ffmpeg
    keycastr
    mongodb-compass
    obsidian

    # Databases and messaging
    mongodb-atlas-cli
    mongosh
    mqttui
    mqttx-cli
    acli
    glab
    natscli
  ];
}
