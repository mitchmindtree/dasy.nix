{
  dasy,
  lib,
  stdenv,
  symlinkJoin,
}: {
  name ? "${args.pname}-${args.version}",
  src ? null,
  preUnpack ? null,
  unpackPhase ? null,
  postUnpack ? null,
  patches ? [],
  buildInputs ? [],
  nativeBuildInputs ? [],
  meta ? {},
  # The directory from which the `dasy` command should be run relative to `src`.
  buildDir ? ./.,
  # Dirs containing `*.dasy` contracts relative to `src`.
  contracts ? ["contracts"],
  # The output formats to generate with `dasy`. See `dasy -h` for options.
  formats ? ["bytecode" "abi"],
  ...
} @ args: let
  # A map from format to the suffix to add to the file path.
  formatSuffix = {
    bytecode = ".bin";
    bytecode_runtime = ".bin";
    abi = "-abi.json";
    abi_python = "-abi.py";
    source_map = "-source-map.vy";
    method_identifiers = "-method-identifiers.json";
    layout = "-layout.json";
    opcodes = ".opcodes";
    opcodes_runtime = ".opcodes";
    ir = ".ir";
    ir_json = "-ir.json";
    metadata = "-metadata.json";
  };

  # A function for creating an individual contract derivation.
  buildDasyContract = contractRelative: let
    buildDasyContractFormat = format:
      stdenv.mkDerivation (args
        // {
          pname = "${contractRelative}-${format}";
          buildInputs = args.buildInputs or [] ++ [dasy];
          buildPhase = ''
            local contractPath=$src/${contractRelative}
            local baseName=$(basename ''$contractPath .dasy)
            mkdir -p $out/contract/$baseName
            echo "Building $contractPath"
            dasy -f ${format} ''$contractPath > ''$out/contract/$baseName/$baseName${formatSuffix.${format} or ".${format}"}
          '';
        });
    builtFormats = map buildDasyContractFormat formats;
  in
    symlinkJoin {
      name = contractRelative;
      paths = builtFormats;
    };

  # Process an item in `contracts` (either a single contract, or a directory of them).
  processContractItem = item: let
    isDasyFile = path: lib.pathIsRegularFile path && lib.hasSuffix ".dasy" path;
    fullPath = "${src}/${item}";
  in
    if lib.pathIsDirectory fullPath
    then let
      entries = lib.filesystem.listFilesRecursive fullPath;
      contracts = builtins.filter isDasyFile entries;
      contractsRelative = map (p: builtins.replaceStrings ["${src}/"] [""] p) contracts;
    in
      map buildDasyContract contractsRelative
    else if isDasyFile fullPath
    then [(buildDasyContract item)]
    else throw "Provided item `${item}` in `contracts` list is not a dasy contract or directory";

  # Flatten the list of derivations
  contractDerivations = lib.flatten (map processContractItem contracts);
  # Create a final derivation to link the contracts together.
in
  symlinkJoin {
    name = "${args.pname}-${args.version}";
    paths = contractDerivations;
  }
