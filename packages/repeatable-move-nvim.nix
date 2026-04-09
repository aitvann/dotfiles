{
  vimUtils,
  fetchFromGitHub,
  vimPlugins,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "repeatable-move-nvim";
  version = "2026-04-1";
  src = fetchFromGitHub {
    owner = "kiyoon";
    repo = "repeatable-move.nvim";
    rev = "0c8d75dc04e2c149a9de1beff2e85dabb99990ef";
    sha256 = "sha256-/410crgpvIHqObuzdLoVBaKHdPnTBZL3YfbPpjG6DoY=";
  };
  dependencies = with vimPlugins; [
    nvim-treesitter-textobjects
  ];
  meta.homepage = "https://github.com/kiyoon/repeatable-move.nvim";
}
