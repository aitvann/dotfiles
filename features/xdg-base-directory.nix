{
  inputs,
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "xdg-base-directory" ({lib, ...}: {
    environment.sessionVariables = let
      vars = inputs.self.util.read-env-file "${inputs.self}/stow-home/wayland/.config/uwsm/env.d/10-xdg";
    in
      builtins.mapAttrs (_: v: lib.mkDefault v) vars;
  });
}
