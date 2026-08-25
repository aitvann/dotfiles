{...}: {
  flake.modules.nixos.wayland = {
    pkgs,
    lib,
    packageSystemFiles,
    ...
  }: {
    services.displayManager.regreet.enable = true;
    # TODO: figure out smooth plymouth transition as it is not supported out of the box
    # https://todo.sr.ht/~kennylevinsen/greetd/17
    services.greetd.greeterManagesPlymouth = false;
    xdg.portal.enable = true;
    # TODO: integrate `pass`:
    # - https://github.com/grimsteel/pass-secret-service -- not packaged for nix
    # - https://github.com/mdellweg/pass_secret_service -- times out
    services.gnome.gnome-keyring.enable = true;
    # FIX: should unlocks keyring upon login. greetd does not subtask login
    # https://github.com/NixOS/nixpkgs/issues/357201
    # https://wiki.nixos.org/wiki/Secret_Service#Auto-decrypt_on_login
    # doest not work
    security.pam.services.login.enableGnomeKeyring = true;
    # FIX: figure out why doesn't work
    security.pam.services.login.gnupg.enable = true;
    security.pam.services.login.gnupg.storeOnly = true;
    security.pam.services.greetd.gnupg.enable = true;
    security.pam.services.greetd.gnupg.storeOnly = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    services.pipewire.extraLadspaPackages = with pkgs; [rnnoise-plugin];

    environment.etc = lib.mkMerge [
      (packageSystemFiles "greetd-general")
      (packageSystemFiles "regreet")
    ];

    environment.systemPackages = with pkgs; [
      cage
      regreet
    ];
  };

  flake.modules.homeManager.wayland = {
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        # Will cause massive rebuilds
        # Source: https://github.com/JManch/nixos/blob/34f070afdbc0e1ec3185e84e8d36fd4fa3e9d716/modules/home-manager/desktop/uwsm.nix#L38
        # xdg-utils = prev.xdg-utils.overrideAttrs (old: {
        #   postFixup =
        #     (old.postFixup or "")
        #     + ''
        #       rm $out/bin/xdg-open
        #       ln -s ${prev.app2unit}/bin/app2unit-open $out/bin/xdg-open
        #     '';
        # });

        # HACK:
        # Fixing broken desktop entry that app2unit is sensitive for
        # https://github.com/Vladimir-csp/app2unit/issues/9#issuecomment-3175908089
        oculante = prev.oculante.overrideAttrs (oldAttrs: {
          postInstall =
            (oldAttrs.postInstall or "")
            + ''
              substituteInPlace $out/share/applications/oculante.desktop \
                --replace "oculante %U" "oculante %F"
            '';
        });
      })
    ];

    services.wl-clip-persist.enable = true;

    home.packages = with pkgs; [
      app2unit
      wl-clipboard
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "wayland")
      (packageHomeFiles "pipewire-${config.home.username}")
      (packageHomeFiles "wireplumber")
      (packageHomeFiles "pulse")
    ];
  };
}
