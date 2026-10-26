{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "cratesio-mcp";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "cratesio-mcp";
    rev = "v${version}";
    sha256 = "sha256-LgMGmbuay4Nx/qetKsBnrE7B13MTc6hwYponpzSHayk=";
  };

  cargoHash = "sha256-9EACmU6WFwNkuLlozaO+9W08ZTgnnaNsR+U54E/opHw=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  meta = with lib; {
    description = "MCP server for querying crates.io, the Rust package registry";
    homepage = "https://github.com/joshrotenberg/cratesio-mcp";
    license = licenses.mit;
    mainProgram = "cratesio-mcp";
  };
}
