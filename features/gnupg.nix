{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;

  # Make sure it matches `GNUPGHOME` environment variable
  homedir = "${config.xdg.configHome}/gnupg";
in {
  # Required for `gpg-agent` to work correctly
  programs.gpg.homedir = homedir;
  services.gpg-agent = {
    enable = true;
    # Required for enabling ssh socket
    enableSshSupport = true;
  };

  home.packages = with pkgs; [
    gnupg
  ];

  home.file = lib.mkMerge [
    {
      # Using Stow package instead
      "${homedir}/gpg-agent.conf".enable = false;
    }

    (packageHomeFiles ../stow-home/gnupg)
  ];
}
