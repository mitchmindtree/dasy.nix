{
  description = ''
    A dasy project.
  '';

  inputs = {
    dasy.url = "github:mitchmindtree/dasy.nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs: let
    perSystemPkgs = f:
      inputs.nixpkgs.lib.genAttrs (import inputs.systems)
      (system: f (import inputs.nixpkgs {inherit system;}));
  in {
    packages = perSystemPkgs (pkgs: {
      foo = inputs.dasy.lib.${pkgs.system}.buildDasyPackage {
        src = ./.;
        pname = "foo";
        version = "0.1.0";
        contracts = [
          "contracts/foo.dasy"
        ];
      };
      default = inputs.self.packages.${pkgs.system}.foo;
    });

    devShells = perSystemPkgs (pkgs: {
      foo-dev = pkgs.mkShell {
        inputsFrom = [
          inputs.self.packages.${pkgs.system}.foo
        ];
        buildInputs = [
          inputs.dasy.packages.${pkgs.system}.dasy
          # Add other dev tools here, e.g. foundry, etc.
        ];
      };
      default = inputs.self.devShells.${pkgs.system}.foo-dev;
    });
  };
}
