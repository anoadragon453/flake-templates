{
  description = "A collection of project templates";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    {
      templates = {
        go = {
          path = ./templates/dev/go;
          description = "Simple Golang project";
        };

        python = {
          path = ./templates/dev/python;
          description = "Simple python project";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}
