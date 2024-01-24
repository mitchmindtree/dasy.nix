{
  buildPythonPackage,
  colorama,
  fetchPypi,
  funcparserlib,
}:
buildPythonPackage rec {
  pname = "dasy-hy";
  version = "0.24.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q9dwPyw8YRTHIVJaD1ETFG2o64wrI7rdli639A1J82k=";
  };
  propagatedBuildInputs = [
    colorama
    funcparserlib
  ];
  doCheck = false;
}
