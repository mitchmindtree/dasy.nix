# dasy.nix

A Nix flake for the Dasy experimental lisp-like smart contract language.

## Usage

1. Install Nix, easiest with the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer).

2. Use Nix to enter a shell with the `dasy` CLI:
   ```console
   nix shell github:mitchmindtree/dasy.nix
   ```

3. Check that it works with:
   ```console
   dasy -h
   ```

## Create a new Dasy project

You can create a new standalone dasy project with:

```console
nix flake new --template github:mitchmindtree/dasy.nix my-project
cd my-project
```

Test that the project builds with:

```console
nix build
```

If you have `tree` installed, see the compiled project with:

```console
$ tree result

result
└── contract
    └── foo
        ├── foo-abi.json -> /nix/store/pand0klzv4n7r62f0p76v67y8lm9r1j2-contracts-foo.dasy-abi-0.1.0/contract/foo/foo-abi.json
        └── foo.bin -> /nix/store/4b5qmbdd40xdxwv5f3y0cx1hrsl0rd87-contracts-foo.dasy-bytecode-0.1.0/contract/foo/foo.bin
```

Enter a shell with `dasy` available to hack on your project:

```
$ nix develop

$ dasy contracts/foo.dasy
```
