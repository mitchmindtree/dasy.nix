# An example of packaging the hello_world.dasy example from the dasy repo.
{
  buildDasyPackage,
  dasy,
}:
buildDasyPackage {
  src = "${dasy.src}";
  pname = "hello-world";
  version = "0.1.0";
  contracts = ["examples/hello_world.dasy"];
}
