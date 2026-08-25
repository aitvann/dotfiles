{
  inputs,
  lib,
  ...
}: {
  options = {
    flake.deploy.nodes = lib.mkOption {
      type = lib.types.attrs;
      description = "A mapper for deploy-rs.";
      default = {};
    };
  };

  config = {
    perSystem = {system, ...}: {
      # This is highly advised, and will prevent many possible mistakes
      checks = inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy;
    };
  };
}
