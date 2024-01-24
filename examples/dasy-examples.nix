# An example of packaging all examples from the dasy repo in one package.
{
  buildDasyPackage,
  dasy,
}:
buildDasyPackage {
  src = "${dasy.src}";
  pname = "dasy-examples";
  version = "0.1.0";
  contracts = ["examples"];
  # Just for fun, we output some extra dasy formats for each example.
  formats = ["abi" "bytecode" "abi_python" "metadata"];
}
