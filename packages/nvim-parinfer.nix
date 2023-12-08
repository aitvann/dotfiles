{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-parinfer";
  version = "2023-08-09";
  src = fetchFromGitHub {
    owner = "gpanders";
    repo = "nvim-parinfer";
    rev = "5ca09287ab3f4144f78ff7977fabc27466f71044";
    sha256 = "sha256-diwLtmch8LzaX7FIwBNy78n3iY7VnqMC1n0ep8k5kWE=";
  };
  meta.homepage = "https://github.com/gpanders/nvim-parinfer";
}
