let
  makboek = "ssh-ed25519 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFqUkC4sOTUEsNfv6ueUUWG1juVvdFoEt8C3v31Z6ad";
  branco = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBDTzMseGTUyf73n/To64ATwhVfp1mkkhcwzFrw4+uj";

  systems = [makboek];
  users = [branco];

  work = [makboek branco];
in {
  "git/work.age".publicKeys = work;
}
