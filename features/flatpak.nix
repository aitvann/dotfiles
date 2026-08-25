{inputs, ...}: {
  flake.modules.nixos.flatpak = {...}: {
    services.flatpak.enable = true;
  };

  flake.modules.homeManager.flatpak = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = [
      inputs.flatpaks.homeModules.default
    ];

    services.flatpak = {
      enable = true;
      preSwitchCommand = ''
        # https://github.com/in-a-dil-emma/declarative-flatpak/issues/30#issuecomment-2360118207
        ${lib.getExe pkgs.flatpak} override --user --unshare=network md.obsidian.Obsidian
      '';
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
      packages = [
        "flathub:app/com.github.tchx84.Flatseal//stable"
        "flathub:app/md.obsidian.Obsidian//stable"
        # TODO: fix screen sharing (works with native package)
        "flathub:app/de.shorsh.discord-screenaudio//stable"
      ];
    };

    home.file = lib.mkMerge [
      (packageHomeFiles "flatpak")
    ];
  };
}
