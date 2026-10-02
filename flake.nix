{
  description = "ICC dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/b6bfbdf005461848579778f046ff8034a5ffaa42";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        opam
        gmp
        autoconf
        which
        libffi
        pkg-config
      ];
    };
  };
}
