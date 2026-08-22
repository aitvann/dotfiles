{inputs, ...}: let
  util = inputs.self.util;
in {
  flake.modules.homeManager.nnn = {
    config,
    pkgs,
    lib,
    ...
  }: let
    packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
  in {
    imports = with inputs.self.modules.homeManager; let
      preview-tui-deps = [../../features/bat.nix];
      gitroot-deps = [../../features/git.nix];
      clipboard-plugin-deps = [../../features/babashka.nix];
    in
      [
        ../../modules/unfree.nix
        stowfulNnn
        ../../features/term.nix
      ]
      ++ preview-tui-deps ++ gitroot-deps ++ clipboard-plugin-deps;

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
            (old.postFixup or "")
            + ''
              ln -s ${prev.awww}/bin/awww $out/bin/swww
            '';
        });
      })
    ];

    nixpkgs.allowedUnfreePackages = [
      "unrar"
    ];

    programs.nnn = {
      enable = true;

      extraPackages = let
        # See https://github.com/jarun/nnn/wiki/Usage#dependencies
        base-deps = with pkgs; [
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

        dragdrop-deps = with pkgs; [dragon-drop];
        fzcd-deps = with pkgs; [fzf findutils];
        xdgdefault-deps = with pkgs; [xdg-utils fzf];
        fzopen-deps = with pkgs; [findutils fzf xdg-utils];
      in
        base-deps ++ dragdrop-deps ++ fzcd-deps ++ xdgdefault-deps ++ fzopen-deps;
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
      (packageHomeFiles ../../stow-home/nnn)
    ];
  };
}
