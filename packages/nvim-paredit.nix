{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-paredit";
  version = "2023-10-26";
  src = fetchFromGitHub {
    owner = "julienvincent";
    repo = "nvim-paredit";
    rev = "58187546e73504f5fdf6a6074031ed845efa86f8";
    sha256 = "sha256-AVyKw8pLokld+9a1h5EbKJpbyfOBF8kjbMyQKWB6e4I=";
  };
  meta.homepage = "https://github.com/julienvincent/nvim-paredit";
}
