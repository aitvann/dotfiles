{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "fzf-lua-frecency";
  version = "2026-01-25";
  src = fetchFromGitHub {
    owner = "elanmed";
    repo = "fzf-lua-frecency.nvim";
    rev = "5726403e132fe8699d670c7ef8d59dbed887b4e6";
    sha256 = "81FwV/rmFv5wbP1KtnvC+kwvUmg60lqk1haGwuV2N+A=";
  };
  meta.homepage = "https://github.com/elanmed/fzf-lua-frecency.nvim";
}
