{ dasy
, mkShell
, poetry
,
}:
mkShell {
  inputsFrom = [
    dasy
  ];
  buildInputs = [
    poetry
  ];
}
