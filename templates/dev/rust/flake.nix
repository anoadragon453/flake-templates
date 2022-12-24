{
  description = "A Rust development environment";

  # This overlay allows us to choose rust versions other than latest if desired,
  # as well as provides the rust-src extension.
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };

      # Select the latest, stable rust release
      rust_version = "latest";
      rust = pkgs.rust-bin.stable.${rust_version}.default.override {
        extensions = [
          # rust-analyzer requires this extension to work properly
          "rust-src"
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rust
          cargo
          clippy
          rust-analyzer
          rustfmt
        ];

        # Set RUST_SRC_PATH environment variable for rust-analyzer to make use of.
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    });
}
