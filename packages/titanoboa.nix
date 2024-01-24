{ buildPythonPackage
, eth-account
, eth-stdlib
, fetchPypi
, hypothesis
, hyrule
, py-evm
, pytest
, rich
, setuptools
, trie
, vyper
,
}:
buildPythonPackage rec {
  pname = "titanoboa";
  version = "0.1.8";
  format = "pyproject";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-X8OmY4remIXR0nE2fU4F2Rvc4kbnBkiCGWzNITq5J80=";
  };
  propagatedBuildInputs = [
    eth-account
    eth-stdlib
    hypothesis
    hyrule
    py-evm
    pytest
    rich
    setuptools
    trie
    vyper
  ];
  doCheck = false;
}
