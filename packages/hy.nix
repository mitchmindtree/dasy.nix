{ buildPythonPackage
, colorama
, fetchPypi
, funcparserlib
}:
buildPythonPackage rec {
  pname = "hy";
  version = "0.25.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UO2Ig0sDoz/CW4XYiXu+FbeEa4TTJGMKzo0FL31IMns=";
  };
  propagatedBuildInputs = [
    colorama
    funcparserlib
  ];
  doCheck = false;
}
