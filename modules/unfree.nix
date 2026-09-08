# Inspiration: https://qiita.com/naogami/items/a87049008029cf318f6b#unfreenix%E3%82%92%E8%BF%BD%E5%8A%A0
{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "unfree" ({
    config,
    lib,
    ...
  }: {
    options.nixpkgs.allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    options.nixpkgs.allowSomeUnfree = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow some explicedly named unfree packages";
    };

    config = let
      predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
    in {
      assertions = [
        {
          assertion = !config.nixpkgs.allowSomeUnfree -> (builtins.length config.nixpkgs.allowedUnfreePackages == 0);
          message = "Unfree packages are not allowed see `nixpkgs.allowSomeUnfree`";
        }
      ];

      nixpkgs.config.allowUnfreePredicate = predicate;
    };
  });

  options.modules.nixos = mkModuleOption "unfree" ({
    config,
    lib,
    ...
  }: {
    options.nixpkgs.allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    options.nixpkgs.allowSomeUnfree = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow some explicedly named unfree packages";
    };

    config = let
      predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
    in {
      assertions = [
        {
          assertion = !config.nixpkgs.allowSomeUnfree -> (builtins.length config.nixpkgs.allowedUnfreePackages == 0);
          message = "Unfree packages are not allowed see `nixpkgs.allowSomeUnfree`";
        }
      ];

      nixpkgs.config.allowUnfreePredicate = predicate;
    };
  });
}
