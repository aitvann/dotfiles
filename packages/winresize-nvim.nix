{
  vimUtils,
  fetchFromGitHub,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "winresize-nvim";
  version = "2025-01-06";
  src = fetchFromGitHub {
    owner = "pogyomo";
    repo = "winresize.nvim";
    rev = "df7ac44154565b0bb91a8894ffe57c5a93689f10";
    sha256 = "sha256-g+2JAzYiTOA2MuJ3eSdnTWObx96UAheFsslVvQgitFI=";
  };
  meta.homepage = "https://github.com/pogyomo/winresize.nvim";
}
