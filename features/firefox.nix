{
  inputs,
  config,
  pkgs,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    (final: prev: {
      firefox = prev.firefox.override {nativeMessagingHosts = with pkgs; [ff2mpv-rust];};
    })
  ];

  # MANUAL (UPDATE): go to Bookmarks Manager and import
  programs.firefox = {
    enable = true;
    profiles = let
      shared-extensions = with pkgs.firefox-addons; [
        # filters: https://github.com/yokoffing/filterlists
        #
        # there are two way of confiugring uBlock Origin:
        # - old: `adminSettings` was added a long time ago as a quick way to set any setting,
        #   but its use is a bit complicated because it requires double-JSON encoding.
        #   guide: https://www.reddit.com/r/uBlockOrigin/comments/o7q2ou/comment/h3cplhd/?utm_source=share&utm_content=share_button.
        #   can be done automatically with Nix: https://discourse.nixos.org/t/generate-and-install-ublock-config-file-with-home-manager/19209
        # - new: https://github.com/gorhill/uBlock/wiki/Deploying-uBlock-Origin:-configuration
        #
        # MANUAL (UPDATE): go to UBlockOrigin settings:
        # 1. backup Settings
        # 2. backup My Filters (don't forget to eacape escapes)
        # 3. update `managed-storage` file
        ublock-origin

        # MANUAL: go to extension settings and import options manually
        vimium
        # MANUAL: go to extension settings and import options manually
        ublacklist
        # MANUAL: go to extension settings and import options manually
        zeroomega
        simple-translate

        simplelogin
        fastforwardteam
        rust-search-extension
        web-archives
        canvasblocker
        ff2mpv

        # cookies blocker
        # uBlock filter lists avaliable for that purpose but work less efficient
        # https://www.reddit.com/r/uBlockOrigin/comments/11tpnuk/comment/jckr3e2/
        istilldontcareaboutcookies
        # consent-o-matic

        # TODO: Try It
        # auto-tab-discard
        # multi-account-containers
        # bypass-paywalls-clean

        # Tried
        # clearurls # covered by ublock-origin.
        # buster-captcha-solver # does not work
        # browserpass # use rofi
        # flagfox # unfree
        # draw-io-for-nation # missing for FF
      ];
    in {
      general = {
        id = 0;
        extensions.packages = with pkgs.firefox-addons;
          [
            # MANUAL: go to extension settings and import options manually
            sponsorblock

            # search-by-image # became not available at some point
            return-youtube-dislikes
            markdownload
            new-minecraft-wiki-redirect

            # Crypto
            metamask
            joinfire
            phantom-app
            tonkeeper
            braavos-wallet
            revoke-cash
            # core-wallet # missing for FF
            # tronlink # missing for FF
          ]
          ++ shared-extensions;
      };
      work = {
        id = 1;
        extensions.packages = shared-extensions;
      };
    };
  };

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/firefox)
  ];

  xdg.dataFile = util.recursiveMerge [
    # bookmarks
    (util.linkFiles "configs/browser-bookmarks.general.html" "firefox/bookmarks.general.html" inputs.self)
    (util.linkFiles "configs/browser-bookmarks.work.html" "firefox/bookmarks.work.html" inputs.self)
  ];
}
