{ pkgs, lib, ... }:
with lib; rec {
  mkWPackageOption =
    # Package set (a specific version of nixpkgs or a subset)
    pkgs:
    # Name for the package, shown in option description
    name:
    {
      # The attribute path where the default package is located
      default ? name
    , # A string or an attribute path to use as an example
      example ? null
    , # Additional text to include in the option description
      extraDescription ? ""
    , binary ? null
    ,
    } @ pkgattrs:
    let
      name' = if isList name then last name else name;
      binary' = if isNull binary then name' else binary;
      default' = if isList default then default else [ default ];
      defaultPath = concatStringsSep "." default';
      defaultValue = attrByPath default'
        (throw "${defaultPath} cannot be found in pkgs")
        pkgs;
      wPkgType = with types; submodule {
        options.package = mkPackageOption pkgs name (removeAttrs pkgattrs [ "binary" ]);
        options.binary = mkOption {
          type = str;
          default = binary';
          defaultText = literalExpression name';
        };
      };
    in
    mkOption {
      defaultText = literalExpression ("pkgs." + defaultPath);
      type = with types; coercedTo package (p: { package = p; }) wPkgType;
      description = "The ${name'} package and it's binary name to use."
        + (if extraDescription == "" then "" else " ") + extraDescription;
      ${if default != null then "default" else null} = defaultValue;
      ${if example != null then "example" else null} = literalExpression
        (if isList example then "pkgs." + concatStringsSep "." example else example);
    };

  mkDepsOption = example: mkOption {
    type = types.listOf types.package;
    default = [ ];
    example = if isList example then example else [ example ];
    description = ''
      List of config dependenties.
    '';
  };

  mkConfigOption = example: mkOption {
    type = with types; attrsOf path;
    default = [ ];
    inherit example;
    description = ''
      Attribute set of package's configuration files to link in the home directory.
    '';
  };

  stowConfig =
    let
      toList = set: map
        (name: { inherit name; value = set.${name}; })
        (builtins.attrNames set);
      readF = path: kind:
        if kind == "directory"
        then readRec path (builtins.readDir path)
        else path;
      readRec = path: dir: builtins.mapAttrs (file: readF (path + "/${file}")) dir;
      read = path: readRec path (builtins.readDir path);
      flatten = prev: builtins.concatMap ({ name, value }:
        let
          prevPath = (if prev == "" then prev else prev + "/") + name;
        in
        if builtins.isAttrs value
        then flatten prevPath (toList value)
        else [ prevPath ]);
      readDir = path: flatten "" (toList (read path));
    in
    target: package:
      let
        paths = map (p: { name = p; value = package + "/${p}"; }) (readDir package);
      in
      builtins.listToAttrs paths;

  wrapPackage = pkgs: path: { binary ? null
                            , dependencies ? [ ]
                            , newName ? null
                            ,
                            }:
    let
      pathParts = if isList path then path else [ path ];
      name = last pathParts;
      binary' = if isNull binary then name else binary;
      pkgPath = concatStringsSep "." pathParts;
      pkg = attrByPath pathParts
        (throw "${pkgPath} cannot be found in pkgs")
        pkgs;
      newName' = if isNull newName then "wc-${name}" else newName;
      prefix = toString (map (p: "--prefix PATH : ${p}/bin") dependencies);
    in
    pkgs.symlinkJoin {
      name = newName';
      paths = [ pkg ];
      buildInputs = with pkgs; [ makeWrapper ];
      postBuild = ''  
        wrapProgram $out/bin/${binary'} ${prefix}
      '';
    };

  # stowPackage = path: {
  #   enable = true;
  #   dependencies = import "${path}/deps.nix" pkgs;
  # }
}
