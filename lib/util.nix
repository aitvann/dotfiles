{ lib, ... }: with lib; rec {
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

  packageHomeFiles = target: package: 
    builtins.mapAttrs (n: v: { source = v; }) (stowConfig target package);

  recursiveMerge = attrList:
    let f = attrPath:
      zipAttrsWith (n: values:
        if tail values == []
          then head values
        else if all isList values
          then unique (concatLists values)
        else if all isAttrs values
          then f (attrPath ++ [n]) values
        else last values
      );
    in f [] attrList;
}
