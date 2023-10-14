{ fetchurl
, fetchFromGitHub
, graphicsmagick
, lib
, makeDesktopItem
, makeWrapper
, nix-update-script
, stdenv

  # Dependencies
, jre
}:

let
  java = jre.override { enableJavaFX = true; };
in
stdenv.mkDerivation rec {
  pname = "mcaselector";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${version}/mcaselector-${version}.jar";
    hash = "sha256-tOSdzLFxvEJ9LXliwfosMkgcrQLsrW7qDS8vrgPzQoI=";
  };
  dontUnpack = true;

  iconSrc = fetchFromGitHub {
    owner = "Querz";
    repo = "mcaselector";
    rev = "ccb5d2570350f97f4c3c58753aefbd2a89b4e2c1";
    sparseCheckout = [ "src/main/resources/img/icon.png" ];
    hash = "sha256-MUx+xB7irlkbLqbXvovZ2xG63Wp33ARWQFszB3eBOwM=";
  };

  desktopItem = makeDesktopItem {
    categories = [ "Utility" ];
    genericName = "Minecraft chunk editor";
    desktopName = "MCA Selector";
    name = pname;
    icon = pname;
    exec = meta.mainProgram;
  };

  nativeBuildInputs = [ graphicsmagick makeWrapper ];
  buildPhase = ''
    gm convert $iconSrc/src/main/resources/img/icon.png \
      -filter 'point' -resize '1600%' ${pname}.png
  '';

  installPhase = ''
    install -D $src $out/share/${pname}.jar
    makeWrapper ${java}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/${pname}.jar"

    install -D -t $out/share/icons ${pname}.png
    install -D -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/${pname} --version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A tool to select chunks from Minecraft worlds for deletion or export.";
    homepage = "https://github.com/Querz/mcaselector";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}

