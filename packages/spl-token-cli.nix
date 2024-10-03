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
  pname = "spl-token-cli";
  # version = "3.4.1";
  version = "4.1.1";

  src = fetchCrate {
    inherit pname version;
    # sha256 = "sha256-picpXKNFAMyhm1NxVRb/kVBgyr/opWyFDIomk8qhma8="; # 3.4.1
    sha256 = "sha256-y2Ni99boQ8lcVFg7IzTCip1/FZYDQiStNiCG5lETRC0="; # 3.4.1
  };

  # cargoHash = "sha256-/hUxDUI1M044Xi3WqqPbiMNWzuNZz6Gz/dN3lm+FLNM="; # 3.4.1
  cargoHash = "sha256-uYZ5RJ5MD+lXNc7H2RupvQTi35+L3bfld5S5NU6CFWI="; # 3.4.1
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
