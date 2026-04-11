{
  vimUtils,
  fetchFromGitHub,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "tiny-cmdline-nvim";
  version = "2026-04-1";
  src = fetchFromGitHub {
    owner = "rachartier";
    repo = "tiny-cmdline.nvim";
    rev = "ad58747b955d0743ccfd56e97da1a4c1fac89f58";
    sha256 = "sha256-tD1DrY4mpPf5Qo9jZEBqSxOOqzk2Ssl1srH4mu+cN5g=";
  };
  meta.homepage = "https://github.com/rachartier/tiny-cmdline.nvim";
}
