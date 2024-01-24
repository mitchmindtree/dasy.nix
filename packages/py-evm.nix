{ buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "py-evm";
  version = "0.8.0b1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oILu7xTVGJt/mMdsKz118r2+IFRH5XrdJ8HDkvXVVUQ=";
  };
  doCheck = false;
}
