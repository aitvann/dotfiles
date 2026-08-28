{
  config',
  inputs,
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "nnn" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; let
      base-deps = [term];
      preview-tui-deps = [bat];
      clipboard-plugin-deps = [babashka];
    in
      base-deps ++ preview-tui-deps ++ clipboard-plugin-deps;

    nixpkgs.overlays = [
      (final: prev: {
        nnn = (prev.nnn.override {withNerdIcons = true;}).overrideAttrs (old: {
          makeFlags = old.makeFlags ++ ["O_GITSTATUS=1" "O_RESTOREPREVIEW=1"];
        });
        nnnPlugins =
          final.callPackage ./nnn-plugins.pkg.nix {}
          // {
            better-preview-tui = final.callPackage ./better-preview-tui.pkg {};
          };

        advcpmv = inputs.advcpmv.packages.${prev.stdenv.hostPlatform.system}.default;
        # HACK: wallpaper plugin still uses deprecated swww
        awww = prev.awww.overrideAttrs (old: {
          postFixup =
            # HACK: Using `ln -f` because this overlay is applied as
            # meny times as this module gets imported
            (old.postFixup or "")
            + ''
              ln -sf ${prev.awww}/bin/awww $out/bin/swww
            '';
        });
      })
    ];

    nixpkgs.allowedUnfreePackages = [
      "unrar"
    ];

    programs.nnn = {
      enable = true;

      extraPackages = with pkgs; let
        # See https://github.com/jarun/nnn/wiki/Usage#dependencies
        base-deps = [
          file
          gnutar
          zip
          unzip
          unrar
          atool
          archivemount
          sshfs
          trash-cli
          advcpmv
        ];

        dragdrop-deps = [dragon-drop];
        fzcd-deps = [fzf findutils];
        gitroot-deps = [git];
        xdgdefault-deps = [xdg-utils fzf];
        fzopen-deps = [findutils fzf xdg-utils];
      in
        base-deps ++ dragdrop-deps ++ fzcd-deps ++ gitroot-deps ++ xdgdefault-deps ++ fzopen-deps;
      plugins = with pkgs.nnnPlugins; [
        helper
        # preview-tui
        better-preview-tui
        dragdrop
        fzcd
        gitroot
        wallpaper
        xdgdefault
        fzopen
      ];
    };

    home.packages = let
      # `extraPackages` does not work for it
      preview-tui-deps = with pkgs; [
        tree
        unzip
        imagemagick
        ffmpeg
        ffmpegthumbnailer
        poppler-utils
        djvulibre
        gnome-epub-thumbnailer
        fontpreview
        glow
      ];
    in
      preview-tui-deps;

    home.file = lib.mkMerge [
      (packageHomeFiles "nnn")
    ];
  });
}
