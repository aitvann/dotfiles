{inputs, ...}: {
  flake.modules.nixos.dev = {...}: {
    # NOTE: requires user in wireshark group
    programs.wireshark.enable = true;

    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
    };

    networking.extraHosts = ''
      127.0.0.1 postgres-test
      127.0.0.1 clickhouse-test
    '';
  };

  flake.modules.homeManager.dev = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      direnv
    ];

    home.packages = with pkgs; [
      # Db
      clickhouse
      postgresql_14

      dbeaver-bin

      # Network
      dig
      tcpdump
      # NOTE: requires to enable `programs.wireshark` for system configuration
      wireshark

      # Web
      grpcui
      grpcurl
      jq

      # Docker
      docker-compose

      # Rust
      cargo
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "dev")
      (packageHomeFiles "cargo")
    ];
  };
}
