{
  argparse,
  black,
  buildPythonPackage,
  dasy-hy,
  eth-abi,
  eth-typing,
  fetchFromGitHub,
  pathspec,
  pluggy,
  titanoboa,
  typing-extensions,
}: let
  src = fetchFromGitHub {
    owner = "z80dev";
    repo = "dasy";
    rev = "d6a09109448ce4acbb7ef94b1645003a6e59e967";
    hash = "sha256-2DjkFDfxqn/i46RypU+FuE6yzURBfsFtb8toabqY3EY=";
  };
  pyproject = builtins.fromTOML (builtins.readFile "${src}/pyproject.toml");
in
  buildPythonPackage {
    inherit src;
    pname = pyproject.tool.poetry.name;
    version = pyproject.tool.poetry.version;
    format = "pyproject";
    propagatedBuildInputs = [
      argparse
      black
      dasy-hy
      eth-abi
      eth-typing
      pathspec
      pluggy
      titanoboa
      typing-extensions
    ];
  }
