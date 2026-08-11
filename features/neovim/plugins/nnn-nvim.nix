{
  vimUtils,
  fetchFromGitHub,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "nnn-nvim";
  version = "2025-04-18";
  src = fetchFromGitHub {
    owner = "luukvbaal";
    repo = "nnn.nvim";
    rev = "efe690293eee87558f034a83ed96157e52639cdb";
    sha256 = "sha256-KRPYHQnKtkd55VOB3ji8U6Chfv2JklQ862KwCUxHp/k=";
  };
  meta.homepage = "https://github.com/luukvbaal/nnn.nvim";
}
