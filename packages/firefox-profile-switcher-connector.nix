{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "firefox-profile-switcher-connector";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "null-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mnPpIJ+EQAjfjhrSSNTrvCqGbW0VMy8GHbLj39rR8r4=";
  };

  nativeBuildInputs = [cmake];

  cargoHash = "sha256-EQIBeZwF9peiwpgZNfMmjvLv8NyhvVGUjVXgkf12Wig=";

  postInstall = ''
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    sed -i s#/usr/bin/ff-pswitch-connector#$out/bin/firefox_profile_switcher_connector# manifest/manifest-linux.json
    cp manifest/manifest-linux.json $out/lib/mozilla/native-messaging-hosts/ax.nd.profile_switcher_ff.json
  '';

  meta = with lib; {
    description = "Native connector software for the 'Profile Switcher for Firefox' extension.";
    homepage = "https://github.com/null-dev/firefox-profile-switcher-connector";
    license = licenses.gpl3;
  };
}
