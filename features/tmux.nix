{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "tmux" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      stowfulTmux
    ];

    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        tokyo-night-tmux
      ];
    };

    home.file = lib.mkMerge [
      (packageHomeFiles "tmux")
    ];
  });
}
