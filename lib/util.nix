{lib, ...}:
with lib; rec {
  stowConfig = let
    toList = set:
      map
      (name: {
        inherit name;
        value = set.${name};
      })
      (builtins.attrNames set);
    readF = path: kind:
      if kind == "directory"
      then readRec path (builtins.readDir path)
      else path;
    readRec = path: dir: builtins.mapAttrs (file: readF (path + "/${file}")) dir;
    read = path: readRec path (builtins.readDir path);
    flatten = prev:
      builtins.concatMap ({
        name,
        value,
      }: let
        prevPath =
          (
            if prev == ""
            then prev
            else prev + "/"
          )
          + name;
      in
        if builtins.isAttrs value
        then flatten prevPath (toList value)
        else [prevPath]);
    readDir = path: flatten "" (toList (read path));
  in
    target: package: let
      paths =
        map (p: {
          name = p;
          value = package + "/${p}";
        })
        (filter (p: p != ".stow-local-ignore") (readDir package));
    in
      builtins.listToAttrs paths;

  packageStowFiles = target: package:
    builtins.mapAttrs (n: v: {source = lib.mkForce v;}) (stowConfig target package);

  # TODO: make smarter
  packageStowFilesCopyCommand = source: files: let
    commands =
      map
      (file: ''
        service_name=$(basename $STATE_DIRECTORY)
        cp --force "${source}/$service_name/${file}" "$STATE_DIRECTORY/${file}"
        chmod 600 "$STATE_DIRECTORY/${file}"
      '')
      files;
    command = lib.concatStringsSep "\n" commands;
  in
    command;

  endsWith = str: suffix: let
    lenStr = stringLength str;
    lenSuffix = stringLength suffix;
    endOfStr = builtins.substring (lenStr - lenSuffix) lenSuffix str;
  in
    endOfStr == suffix;

  linkFiles = source: target: pkg: let
    fullSource = "${pkg}/${source}";
    paths =
      if endsWith source "/"
      then
        assert endsWith target "/"; let
          files = builtins.attrNames (builtins.readDir fullSource);
          fullSourceFiles = map (file: {"${target}${file}" = "${fullSource}${file}";}) files;
        in
          builtins.foldl' (l: r: l // r) {} fullSourceFiles # merge a list of maps
      else {"${target}" = fullSource;};
  in
    builtins.mapAttrs (t: s: {source = s;}) paths;

  zsh-plugin-w-path = package: path: {inherit package path;};

  recursiveMerge = attrList: let
    f = attrPath:
      zipAttrsWith (
        n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values
      );
  in
    f [] attrList;

  dbg = x: lib.trace (builtins.toJSON x) x;
}
