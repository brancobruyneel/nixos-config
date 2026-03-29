{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "rust";
  packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
