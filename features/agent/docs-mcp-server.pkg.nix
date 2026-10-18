{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  makeWrapper,
  python3,
  playwright-driver,
  playwright-test,
}:
buildNpmPackage rec {
  pname = "docs-mcp-server";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "arabold";
    repo = "docs-mcp-server";
    rev = "v${version}";
    hash = "sha256-Al5sSypP3rw96Q4lwkscOkZ4rygRaII79SQu6byEQKw=";
  };

  npmDepsHash = "sha256-6rdcYFYR9EftSs+PeUpGr5Gz+eq6ggDLM5GOAG6O0Vo=";

  nodejs = nodejs_22;

  # Skip playwright browser download during npm install - we use nix-provided browsers
  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  };

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  npmBuildScript = "build";

  postInstall = ''
    # Replace npm-installed playwright with nix-provided version
    rm -rf $out/lib/node_modules/@arabold/docs-mcp-server/node_modules/playwright
    rm -rf $out/lib/node_modules/@arabold/docs-mcp-server/node_modules/playwright-core
    ln -s ${playwright-test}/lib/node_modules/playwright $out/lib/node_modules/@arabold/docs-mcp-server/node_modules/playwright
    ln -s ${playwright-test}/lib/node_modules/playwright-core $out/lib/node_modules/@arabold/docs-mcp-server/node_modules/playwright-core

    # Wrap binary to set playwright browsers path
    wrapProgram $out/bin/docs-mcp-server \
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}
  '';

  meta = with lib; {
    description = "MCP server for fetching and searching documentation";
    homepage = "https://github.com/arabold/docs-mcp-server";
    license = licenses.mit;
    mainProgram = "docs-mcp-server";
  };
}
