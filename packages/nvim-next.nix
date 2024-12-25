{
  vimUtils,
  fetchFromGitHub,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-next";
  version = "2023-09-23";
  src = fetchFromGitHub {
    owner = "ghostbuster91";
    repo = "nvim-next";
    rev = "9c71ab7dd934ed82376cb4a26d3a8baa0048f0e1";
    sha256 = "sha256-ACDsnUqTYok+uea9O/vW4qu/GJgV9d6WTdUCRjSALvo=";
  };
  meta.homepage = "https://github.com/ghostbuster91/nvim-next";
}
