{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "agent" ({
    pkgs,
    lib,
    osConfig,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      stowfulDocsMcpServer
    ];

    nixpkgs.overlays = [
      (final: prev: {
        docs-mcp-server = final.callPackage ./docs-mcp-server.pkg.nix {};
      })
    ];

    services.docs-mcp-server.enable = true;

    # TODO: read from environment file
    systemd.user.services.docs-mcp-server.Service.Environment = [
      "OPENAI_API_BASE=\"http://localhost:11434/v1\""
      "OPENAI_API_KEY=\"none\""
      "DOCS_MCP_EMBEDDING_MODEL=\"EmbeddingGemma-2-VRAM-IGPU\""
      "DOCS_MCP_SCRAPER_SECURITY_FILE_ACCESS_ALLOWED_ROOTS=\"/home/general/playground/docs-mcp-server-local-sources\""
    ];

    programs.pi-coding-agent = {
      enable = true;
    };

    home.packages = with pkgs; [
      openspec

      docs-mcp-server

      # Reqired for Pi to install extentions
      nodejs_22
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "pi-${osConfig.networking.hostName}")
      (packageHomeFiles "docs-mcp-server")
    ];
  });
}
