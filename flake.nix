{
  description = ''
    A nix flake for Dasy Lang.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    let
      overlays = [ inputs.self.overlays.default ];
      perSystemPkgs = f:
        inputs.nixpkgs.lib.genAttrs (import inputs.systems)
          (system: f (import inputs.nixpkgs { inherit overlays system; }));
    in
    {
      packages = perSystemPkgs (pkgs: {
        dasy = pkgs.dasy;
        dasy-examples = pkgs.dasy-examples;
        default = inputs.self.packages.${pkgs.system}.dasy;
      });

      devShells = perSystemPkgs (pkgs: {
        dasy-dev = pkgs.callPackage ./shell.nix { };
        default = inputs.self.devShells.${pkgs.system}.dasy-dev;
      });

      overlays = {
        dasy = import ./overlay.nix;
        default = inputs.self.overlays.dasy;
      };

      templates = {
        new-project = {
          path = ./templates/new-project;
          description = "A simple, default, cross-platform new-project template";
        };
        default = inputs.self.templates.new-project;
      };

      formatter = perSystemPkgs (pkgs: pkgs.nixpkgs-fmt);
    };
}
