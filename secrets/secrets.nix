let
  makboek = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFqUkC4sOTUEsNfv6ueUUWG1juVvdFoEt8C3v31Z6ad";
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKXVTBnzhhlEGlQEnpe8g+L26jw056I9JIlONJW6XZP";

  all = [
    makboek
    nixos
  ];
in
{
  "git/work.age".publicKeys = all;
  "keys/trellis-api.age".publicKeys = all;
}
