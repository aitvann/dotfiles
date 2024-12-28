{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "desktop-notify-nvim";
  version = "2022-05-12";
  src = fetchFromGitHub {
    owner = "simrat39";
    repo = "desktop-notify.nvim";
    rev = "5519667934520468e2a9da3979055091b46dfeec";
    sha256 = "sha256-QT53iar/9obsV8tYU7bZaAmiyRs5ChwrBYiftuaanQ4=";
  };
  meta.homepage = "https://github.com/simrat39/desktop-notify.nvim";
}
