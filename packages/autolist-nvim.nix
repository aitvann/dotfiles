
{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "autolist-nvim";
  version = "2023-07-07";
  src = fetchFromGitHub {
    owner = "gaoDean";
    repo = "autolist.nvim";
    rev = "5f70a5f99e96c8fe3069de042abd2a8ed2deb855";
    sha256 = "sha256-lavDbTFidmbYDOxYPumCExkd27sesZ5uFgwHc1xNuW0=";
  };
  meta.homepage = "https://github.com/gaoDean/autolist.nvim";
}
