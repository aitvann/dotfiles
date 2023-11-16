{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-next";
  version = "2023-09-23";
  src = fetchFromGitHub {
    owner = "ghostbuster91";
    repo = "nvim-next";
    rev = "21171249be2c70b0ccd4c6f8c3eb2a6534e9f10f";
    sha256 = "sha256-dcyg1kjmaHmWyjks485+2KuFcFXjWq8q5GYNu+gMaSc=";
  };
  meta.homepage = "https://github.com/ghostbuster91/nvim-next";
}
