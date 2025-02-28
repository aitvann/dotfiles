{
  fetchCrate,
  lib,
  rustPlatform,
  clang,
  llvm,
  udev,
  pkg-config,
  protobuf,
  openssl,
  zlib,
  libclang,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "solores";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SBL/LGrHYubgwaV1m6jTcU7EiwpUJiEyt3wQNl1jrYk=";
  };

  cargoHash = "sha256-yg8ctdyf3oYx1jJalBbmCJN2WvQI+Orx9t0hNvk6OVc=";
  verifyCargoDeps = true;

  nativeBuildInputs = [clang llvm pkg-config protobuf];
  buildInputs =
    [
      rustPlatform.bindgenHook
      libclang
      openssl
      zlib
    ]
    ++ (lib.optionals stdenv.isLinux [udev]);
  strictDeps = true;

  # Tests build bpf stuff, which we don't need
  doCheck = false;

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;
}
