{
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage rec {
  pname = "bgutil-ytdlp-pot-provider";
  version = "1.1.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "Brainicism";
    repo = "bgutil-ytdlp-pot-provider";
    rev = version;
    hash = "sha256-gcDeLW0MF6Y4Qzaa2nn12lIeK6DB9gSBkBjqsnmdj/M=";
  };
  sourceRoot = "source/plugin";
  build-system = [python3Packages.hatchling];
  doCheck = false;
}
