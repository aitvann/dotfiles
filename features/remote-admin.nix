{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "remote-admin" ({pkgs, ...}: {
    imports = with config'.modules.homeManager; [
      btop
    ];

    home.packages = with pkgs; [
      git
      stow
      # Adding support for Kitty terminal, there might be a better way:
      # - https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-or-functional-keys-like-arrow-keys-don-t-work
      # - https://sw.kovidgoyal.net/kitty/kittens/ssh/#copying-terminfo-files-manually
      kitty

      fastfetch
    ];
  });
}
