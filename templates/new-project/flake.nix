{
  description = ''
    A dasy project.
  '';

  inputs = {
    dasy.url = "github:mitchmindtree/dasy.nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    let
      # Merge dasy packages and our contract package into nixpkgs.
      overlays = [ inputs.dasy.overlays.default inputs.self.overlays.default ];
      # A function providing the nixpkgs set for each platform (i.e. linux, macos).
      perSystemPkgs = f:
        inputs.nixpkgs.lib.genAttrs (import inputs.systems)
          (system: f (import inputs.nixpkgs { inherit overlays system; }));
    in
    {
      # Make `my-contract` available in nixpkgs with an overlay.
      overlays.default = final: prev: {
        my-contract = prev.buildDasyPackage {
          src = ./.;
          pname = "foo";
          version = "0.1.0";
          # The following are defaults, but can be uncommented and changed.
          # contracts = ["contracts"]; # Dirs of contracts and/or specific contract files.
          # formats = ["bytecode" "abi"]; # Dasy output formats to generate on `nix build`.
        };
      };

      # Expose `my-contract` as a package output.
      packages = perSystemPkgs (pkgs: {
        my-contract = pkgs.my-contract;
        default = inputs.self.packages.${pkgs.system}.my-contract;
      });

      # Create a development shell for working on `my-contract`.
      devShells = perSystemPkgs (pkgs: {
        my-contract-dev = pkgs.mkShell {
          inputsFrom = [
            pkgs.my-contract
          ];
          buildInputs = [
            pkgs.dasy
            # Add other dev tools here, e.g. foundry, etc.
          ];
        };
        default = inputs.self.devShells.${pkgs.system}.my-contract-dev;
      });
    };
}
