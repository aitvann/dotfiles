{
  inputs,
  config,
  lib,
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "stow" ({
    config,
    impurity,
    ...
  }: {
    _module.args.packageHomeFiles = pkg:
      inputs.self.util.packageStowFiles impurity config.home.homeDirectory "${inputs.self}/stow-home/${pkg}";
  });

  options.modules.nixos = mkModuleOption "stow" ({impurity, ...}: {
    _module.args.packageSystemFiles = pkg:
      inputs.self.util.packageStowFiles impurity "/etc" "${inputs.self}/stow-system/${pkg}";

    _module.args.packageServiceFilesCopyCommand = pkg:
      inputs.self.util.packageStowFilesCopyCommand "${inputs.self}/stow-service/${pkg}";
  });

  config.flake.flakeConfig = config;
  config._module.args.config' = config;
  config._module.args.mkModuleOption = name: static: {
    ${name} = inputs.self.util.mkModuleOption {
      key = name;
      inherit static;
    };
  };

  config.flake.util = with lib; rec {
    # Source: https://github.com/mightyiam/infra/blob/14f357cc5f78271cb8745122b0f0e4cfb71d435f/modules/lib.nix#L5
    # Fixes duplication issues.
    # Without this a module will be imported every time it is used inside `imports` block
    # which causes `.enable` options conflicts and overlays to apply multiple times (on every import)
    mkModuleOption = args @ {
      key,
      static ? {},
      ...
    }:
      lib.mkOption {
        type = lib.types.deferredModuleWith {
          staticModules = [static];
        };

        ${
          if args ? default
          then "default"
          else null
        } =
          args.default;

        apply = module: {
          inherit key;
          imports = [module];
        };

        default = {};
      };

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
      imp: target: package: let
        paths =
          map (p: {
            name = p;
            # value = package + "/${p}";
            # TODO: use groupedLink once it works. See https://github.com/outfoxxed/impurity.nix/issues/2#issue-5291917440
            # value = imp.groupedLink (baseNameOf package) (package + "/${p}");
            value = imp.link (package + "/${p}");
          })
          (filter (p: p != ".stow-local-ignore") (readDir package));
      in
        builtins.listToAttrs paths;

    packageStowFiles = imp: target: package:
      builtins.mapAttrs (n: v: {source = lib.mkForce v;}) (stowConfig imp target package);

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

    read-env-file = path: let
      content = builtins.readFile path;
      lines = lib.splitString "\n" content;
      parseLine = line: let
        trimmed = lib.trim line;
      in
        if trimmed == "" || lib.hasPrefix "#" trimmed
        then null
        else if lib.hasPrefix "export " trimmed
        then
          let
            rest = lib.removePrefix "export " trimmed;
            parts = lib.splitString "=" rest;
            name = lib.trim (lib.head parts);
            value = lib.trim (lib.concatStringsSep "=" (lib.tail parts));
            unquoted = lib.removePrefix "\"" (lib.removeSuffix "\"" value);
          in
            {inherit name; value = unquoted;}
        else
          null;
      parsed = builtins.filter (x: x != null) (map parseLine lines);
    in
      builtins.listToAttrs parsed;

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

    dbg = x: lib.trace (builtins.toJSON x) x;
  };
}
