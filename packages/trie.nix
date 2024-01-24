{ buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "trie";
  version = "3.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GAIFiD3GFMreUZs4s+T/7LgYTlPVlFVrOPQ0RsXNqEA=";
  };
  doCheck = false;
}
