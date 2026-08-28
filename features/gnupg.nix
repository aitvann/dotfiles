{mkModuleOption, ...}: {
  options.modules.nixos = mkModuleOption "gnupg" ({
    pkgs,
    lib,
    ...
  }: {
    # TODO: figure out how to add package to PATH the proper way
    environment.etc."gnupg/gpg-agent.conf".text = ''
      pinentry-program ${lib.getExe pkgs.pinentry-gnome3}
    '';
  });

  options.modules.homeManager = mkModuleOption "gnupg" ({
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: let
    # NOTE: Make sure it matches `GNUPGHOME` environment variable
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

      (packageHomeFiles "gnupg")
      (packageHomeFiles "pam-gnupg")
    ];
  });
}
