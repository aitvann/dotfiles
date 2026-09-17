{mkModuleOption, ...}: let
  mkImpurityModule = {
    lib,
    config,
    pkgs,
    ...
  }:
    with lib; let
      relativePath = path:
        assert types.path.check path;
        with builtins; strings.removePrefix (toString config.impurity.configRoot) (toString path);

      impurityGroupEnabled = group: let
        groupsStr = builtins.getEnv "IMPURITY_GROUPS";
        impurityGroups = strings.splitString " " groupsStr;
      in
        group == "" || groupsStr == "*" || builtins.elem group impurityGroups;

      impurePath = builtins.getEnv "IMPURITY_PATH";

      createImpurePath = path: let
        relative = relativePath path;
        full = impurePath + relative;
      in
        pkgs.runCommand "impurity-${relative}" {} "ln -s ${full} $out";

      impurity-lib = rec {
        groupedLink = groupspec: path:
        # assert types.string.check groupspec;
          assert types.path.check path; let
            enabled = config.impurity.enable && impurityGroupEnabled groupspec;
          in
            if !enabled
            then path
            else if impurePath == ""
            then path
            else createImpurePath path;

        link = path: groupedLink "" path;
      };
    in {
      options.impurity = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable impure symlinks";
        };

        configRoot = mkOption {
          type = types.path;
          description = "The root of your nixos configuration";
        };
      };

      config._module.args.impurity =
        if config.impurity.enable && impurePath == ""
        then warn "Option impurity.enable is true but IMPURITY_PATH is not set; Falling back to pure linking" impurity-lib
        else impurity-lib;
    };
in {
  options.modules.nixos = mkModuleOption "impurity" mkImpurityModule;
  options.modules.homeManager = mkModuleOption "impurity" mkImpurityModule;
}
