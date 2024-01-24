{ buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "argparse";
  version = "1.4.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YrCJpVvh2JSc0rx+DfC9254Cj678jDIDjMhIYq791uQ=";
  };
}
