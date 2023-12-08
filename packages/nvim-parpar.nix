{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "parpar-nvim";
  version = "2023-09-12";
  src = fetchFromGitHub {
    owner = "dundalek";
    repo = "parpar.nvim";
    rev = "e99a88f0f0b1234f49a3efe9c49b712b58a5acfc";
    sha256 = "sha256-H7cuzjSTimzWYDSDAs6CnhivAoEzU0E+QgrFBzXBwCc=";
  };
  meta.homepage = "https://github.com/dundalek/parpar.nvim";
}
