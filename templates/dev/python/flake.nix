{
  description = "A Python development environment";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (system: {
        # We use mkShellNoCC as we don't need a C compiler here
        default = pkgs.${system}.mkShellNoCC {
          packages = with pkgs.${system}; [
	    jetbrains.pycharm-community
            poetry
          ];
        };
      });
    };
}
