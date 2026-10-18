{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "stowfulDocsMcpServer" (
    {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.services.docs-mcp-server;
    in {
      options.services.docs-mcp-server = {
        enable = lib.mkEnableOption "docs-mcp-server, an MCP server for fetching, indexing and searching documentation";
        package = lib.mkPackageOption pkgs "docs-mcp-server" {};

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Host to bind the server to.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 6280;
          description = "Port to bind the server to.";
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.user.services.docs-mcp-server = {
          Unit = {
            Description = "docs-mcp-server: MCP server for fetching, indexing and searching documentation";
            After = ["network.target"];
          };

          Service = {
            ExecStart = "${lib.getExe cfg.package} --protocol http --host ${cfg.host} --port ${toString cfg.port}";
          };

          Install = {
            WantedBy = ["default.target"];
          };
        };
      };
    }
  );
}
