{
  description = "A basic flake for dotnet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      devShells.${system}.default =
        pkgs.mkShell {
          name = "dotnet-env";
          packages = [
            pkgs.dotnetCorePackages.sdk_10_0
            pkgs.fsautocomplete
          ];
        };
    };
}
