{ pkgs }:
with pkgs.nur.repos.rycee.firefox-addons; [
  ublock-origin
  bitwarden
  vimium
  onepassword-password-manager
]
