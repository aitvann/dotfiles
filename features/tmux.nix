{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "tmux" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
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
