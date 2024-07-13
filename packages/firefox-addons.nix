{
  pkgs,
  fetchurl,
  lib,
  stdenv,
} @ args:
import ./generated-firefox-addons.nix {
  inherit fetchurl lib stdenv;
  buildFirefoxXpiAddon = lib.makeOverridable (
    {
      stdenv ? args.stdenv,
      fetchurl ? args.fetchurl,
      pname,
      version,
      addonId,
      url,
      sha256,
      meta,
      ...
    }:
      stdenv.mkDerivation {
        name = "${pname}-${version}";

        inherit meta;

        src = fetchurl {inherit url sha256;};

        preferLocalBuild = true;
        allowSubstitutes = true;

        buildCommand = ''
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 "$src" "$dst/${addonId}.xpi"
        '';
      }
  );
}
