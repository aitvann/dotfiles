{...}: {
  programs.chromium = let
    extensions = {
      ublock-origin = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      dark-theme = "annfbnbieaamhaimclajlajpijgkdblo";
      simple-translate = "ibplnjkanclpjokhdolnendpplpjiace";
      vimium = "dbepggeogbaibhgnhhndojpepiihcmeb";
      fast-forward = "icallnadddjmdinamnolclfjanhfoafe";
      clear-urls = "lckanjgmijmafbedllaakclkaicjfmnk";
      canvas-fingerprint-defender = "lanfdkkpgfjfdikkncbnojekcppdebfp";
      audio-context-fingerprint-defender = "pcbjiidheaempljdefbdplebgdgpjcbe";
      # i-dont-care-about-cookies = "fihnjjcciajhdojfnbdddfaoknhalnja";
      consent-o-matic = "mdjildafknihdffpkfmmpnpoiajfjnjd";
      json-resume-exporter-from-linkedin = "caobgmmcpklomkcckaenhjlokpmfbdec";
      proxy-switchyomega-3-zero = "pfnededegaaopdmhkdmcofjmoldfiped";
      yt-watch-later-assist = "deafalnegnfhjhejolidiobnapigcfpd";

      # crypto
      core-wallet = "agoakfejjabomempkjlepdflaleeobhb";
      tron-link = "ibnejdfjmmkpcnlpebklmnkoeoihofec";
      phantom-wallet = "bfnaelmomeimhlpmgjnjophhpkkoljpa"; # Some daps does not work in Firefox
    };
  in {
    enable = true;
    extensions = map (name: {id = extensions.${name};}) (builtins.attrNames extensions);
  };
}
