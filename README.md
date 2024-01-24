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
nix flake new --template github:mitchmindtree/dasy.nix my-dapp
cd my-dapp
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
    └── my-contract
        ├── my-contract-abi.json -> /nix/store/czlxsdaajzjigmd4wlhvbp48p59mlf94-contracts-my-contract.dasy-abi-0.1.0/contract/my-contract/my-contract-abi.json
        └── my-contract.hex -> /nix/store/6s6h60fyhpcrhq1i36ckda60ab446v10-contracts-my-contract.dasy-bytecode-0.1.0/contract/my-contract/my-contract.hex
```

Enter a shell with `dasy` available to hack on your project:

```
$ nix develop

$ dasy contracts/my-contract.dasy
```
