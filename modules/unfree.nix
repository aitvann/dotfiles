{
  config,
  lib,
  ...
}: {
  # Inspiration: https://qiita.com/naogami/items/a87049008029cf318f6b#unfreenix%E3%82%92%E8%BF%BD%E5%8A%A0
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
  };

  config = let
    predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
  in {
    nixpkgs.config.allowUnfreePredicate = predicate;
  };
}
