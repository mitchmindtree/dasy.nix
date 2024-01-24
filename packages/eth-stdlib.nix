{ buildPythonPackage
, fetchFromGitHub
, pycryptodome
, poetry-core
}:
buildPythonPackage rec {
  pname = "eth-stdlib";
  version = "0.2.7";
  format = "pyproject";
  src = fetchFromGitHub {
    owner = "skellet0r";
    repo = "eth-stdlib";
    rev = version;
    hash = "sha256-D50s/TaOf622Bz5sK+lueif/IxXOCSVdbnKqYQDfo3o=";
  };
  projectDir = src;
  propagatedBuildInputs = [
    pycryptodome
    poetry-core
  ];
}
