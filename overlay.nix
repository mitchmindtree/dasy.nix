# An overlay that adds the necessary packages including dasy, its python
# dependencies and the `buildDasyPackage` function.
final: prev: {
  python3Packages =
    prev.python3Packages
    // {
      # Add the dasy python dependencies that are missing from nixpkgs.
      argparse = prev.python3Packages.callPackage ./packages/argparse.nix { };
      dasy-hy = prev.python3Packages.callPackage ./packages/dasy-hy.nix { };
      eth-stdlib = prev.python3Packages.callPackage ./packages/eth-stdlib.nix { };
      hy = prev.python3Packages.callPackage ./packages/hy.nix { };
      hyrule = prev.python3Packages.callPackage ./packages/hyrule.nix {
        inherit (final.python3Packages) hy;
      };
      py-evm = prev.python3Packages.callPackage ./packages/py-evm.nix { };
      titanoboa = prev.python3Packages.callPackage ./packages/titanoboa.nix {
        inherit (final.python3Packages) eth-stdlib hyrule py-evm trie;
      };
      trie = prev.python3Packages.callPackage ./packages/trie.nix { };

      # Add the `dasy` package itself!
      dasy = prev.python3Packages.callPackage ./default.nix {
        inherit (final.python3Packages) argparse dasy-hy titanoboa;
      };
    };

  # Make dasy available at the top-level.
  dasy = final.python3Packages.dasy;

  # Make the `buildDasyPackage` function available at the top-level.
  buildDasyPackage = final.callPackage ./packages/build-dasy-package.nix { };

  # Examples of dasy contract packages.
  dasy-hello-world = final.callPackage ./examples/hello-world.nix { };
  dasy-examples = final.callPackage ./examples/dasy-examples.nix { };
}
