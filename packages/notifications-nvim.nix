{
  pkgs,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "notifications-nvim";
  version = "2025-01-07";
  src = fetchFromGitHub {
    owner = "ObserverOfTime";
    repo = "notifications.nvim";
    rev = "c345e664b1b047eb7f98ce060af7c5e3b4ff8850";
    sha256 = "sha256-r3W2sZxNWnkxG8KXaAWI3NIxf8O3wp/Gh6811Qi+OQ4=";
  };
  checkInputs = with pkgs; [glib];
  meta.homepage = "https://github.com/ObserverOfTime/notifications.nvim";
}
