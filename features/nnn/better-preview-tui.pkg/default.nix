{
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  name = "better-preview-tui";
  system = "0.0.1";
  src = ./src;

  phases = ["installPhase" "fixupPhase"];

  installPhase = ''
    install -Dm755 $src/better-preview-tui -t $out/bin
  '';

  meta = with lib; {
    description = "Plugins extend the capabilities of nnn";
    homepage = "https://github.com/jarun/nnn/tree/master/plugins";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
