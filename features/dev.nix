{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    # Db
    sqlite-interactive
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
    (packageHomeFiles ../stow-home/dev)
    (packageHomeFiles ../stow-home/cargo)
  ];
}
