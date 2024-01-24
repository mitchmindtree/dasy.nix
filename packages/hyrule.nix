{
  buildPythonPackage,
  fetchPypi,
  hy,
}:
buildPythonPackage rec {
  pname = "hyrule";
  version = "0.2.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7nNYU+i2VJWx5xiKxxNuVkaOm6Wy0gDhsteKu6mdQDs=";
  };
  propagatedBuildInputs = [
    hy
  ];
  doCheck = false;
}
