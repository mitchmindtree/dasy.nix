{
  description = ''
    A nix flake for Dasy Lang.
  '';

  inputs = {
    dasy-src = {
      url = "github:mitchmindtree/dasy/poetry-lock";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs: let
    # Functions for accessing pkgs per system.
    perSystem = f: inputs.nixpkgs.lib.genAttrs (import inputs.systems) f;
    systemPkgs = system: import inputs.nixpkgs { inherit system; };
    perSystemPkgs = f: perSystem (system: f (systemPkgs system));

    # Attributes from the dasy pyproject.toml.
    pyproject = builtins.fromTOML (builtins.readFile "${inputs.dasy-src}/pyproject.toml");
  in {
    packages = perSystemPkgs (pkgs: let
      pypkgs = pkgs.python3Packages;
      selfpkgs = inputs.self.packages.${pkgs.system};
    in {
      argparse = pypkgs.buildPythonPackage rec {
        pname = "argparse";
        version = "1.4.0";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-YrCJpVvh2JSc0rx+DfC9254Cj678jDIDjMhIYq791uQ=";
        };
      };

      dasy-hy = pypkgs.buildPythonPackage rec {
        pname = "dasy-hy";
        version = "0.24.2";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-q9dwPyw8YRTHIVJaD1ETFG2o64wrI7rdli639A1J82k=";
        };
        propagatedBuildInputs = [
          pypkgs.colorama
          pypkgs.funcparserlib
        ];
        doCheck = false;
      };

      eth-stdlib = pypkgs.buildPythonPackage rec {
        pname = "eth-stdlib";
        version = "0.2.7";
        format = "pyproject";
        src = pkgs.fetchFromGitHub {
          owner = "skellet0r";
          repo = "eth-stdlib";
          rev = version;
          hash = "sha256-D50s/TaOf622Bz5sK+lueif/IxXOCSVdbnKqYQDfo3o=";
        };
        propagatedBuildInputs = [
          pypkgs.pycryptodome
          pypkgs.poetry-core
        ];
        projectDir = src;
      };

      hy = pypkgs.buildPythonPackage rec {
        pname = "hy";
        version = "0.25.0";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-UO2Ig0sDoz/CW4XYiXu+FbeEa4TTJGMKzo0FL31IMns=";
        };
        propagatedBuildInputs = [
          pypkgs.colorama
          pypkgs.funcparserlib
        ];
        doCheck = false;
      };

      hyrule = pypkgs.buildPythonPackage rec {
        pname = "hyrule";
        version = "0.2.1";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-7nNYU+i2VJWx5xiKxxNuVkaOm6Wy0gDhsteKu6mdQDs=";
        };
        propagatedBuildInputs = [
          selfpkgs.hy
        ];
        doCheck = false;
      };

      py-evm = pypkgs.buildPythonPackage rec {
        pname = "py-evm";
        version = "0.8.0b1";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-oILu7xTVGJt/mMdsKz118r2+IFRH5XrdJ8HDkvXVVUQ=";
        };
        doCheck = false;
      };

      trie = pypkgs.buildPythonPackage rec {
        pname = "trie";
        version = "3.0.0";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-GAIFiD3GFMreUZs4s+T/7LgYTlPVlFVrOPQ0RsXNqEA=";
        };
        doCheck = false;
      };

      titanoboa = pypkgs.buildPythonPackage rec {
        pname = "titanoboa";
        version = "0.1.8";
        format = "pyproject";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-X8OmY4remIXR0nE2fU4F2Rvc4kbnBkiCGWzNITq5J80=";
        };
        propagatedBuildInputs = [
          pypkgs.eth-account
          pypkgs.hypothesis
          pypkgs.pytest
          pypkgs.rich
          pypkgs.setuptools
          pypkgs.vyper
          selfpkgs.eth-stdlib
          selfpkgs.hyrule
          selfpkgs.py-evm
          selfpkgs.trie
        ];
        doCheck = false;
      };

      dasy = pypkgs.buildPythonPackage {
        pname = pyproject.tool.poetry.name;
        version = pyproject.tool.poetry.version;
        format = "pyproject";
        src = inputs.dasy-src;
        propagatedBuildInputs = [
          pkgs.black
          pypkgs.eth-abi
          pypkgs.eth-typing
          pypkgs.pathspec
          pypkgs.pluggy
          pypkgs.typing-extensions
          selfpkgs.argparse
          selfpkgs.dasy-hy
          selfpkgs.titanoboa
        ];
      };

      default = selfpkgs.dasy;
    });

    devShells = perSystemPkgs (pkgs: {
      dasy-dev = pkgs.mkShell {
        inputsFrom = [
          inputs.self.packages.${pkgs.system}.dasy
        ];
        buildInputs = [
          pkgs.poetry
        ];
      };
      default = inputs.self.devShells.${pkgs.system}.dasy-dev;
    });

    formatter = perSystemPkgs (pkgs: pkgs.alejandra);
  };
}
