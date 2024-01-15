{
  stdenv,
  nnn,
  lib,
  fetchFromGitHub,
}: let
  version = nnn.version;
  makePluginWithPath = name: path:
    stdenv.mkDerivation {
      pname = "${name}";
      inherit version;
      src = fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v${version}";
        sparseCheckout = ["plugins"];
        hash = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
      };
      dontUnpack = true;

      phases = ["installPhase" "fixupPhase"];

      installPhase = ''
        install -Dm755 $src/plugins/${path} -t $out/bin
      '';

      meta = with lib; {
        description = "Plugins extend the capabilities of nnn";
        homepage = "https://github.com/jarun/nnn/tree/master/plugins";
        license = licenses.bsd2;
        platforms = platforms.all;
      };
    };
  makePlugin = name: makePluginWithPath name name;
in {
  helper = makePluginWithPath "helper" ".nnn-plugin-helper";
  boom = makePlugin "boom";
  bulknew = makePlugin "bulknew";
  cbcopy-mac = makePlugin "cbcopy-mac";
  cbpaste-mac = makePlugin "cbpaste-mac";
  cdpath = makePlugin "cdpath";
  chksum = makePlugin "chksum";
  cmusq = makePlugin "cmusq";
  diffs = makePlugin "diffs";
  dragdrop = makePlugin "dragdrop";
  dups = makePlugin "dups";
  finder = makePlugin "finder";
  fixname = makePlugin "fixname";
  fzcd = makePlugin "fzcd";
  fzhist = makePlugin "fzhist";
  fzopen = makePlugin "fzopen";
  fzplug = makePlugin "fzplug";
  getplugs = makePlugin "getplugs";
  gitroot = makePlugin "gitroot";
  gpgd = makePlugin "gpgd";
  gpge = makePlugin "gpge";
  gsconnect = makePlugin "gsconnect";
  gutenread = makePlugin "gutenread";
  imgresize = makePlugin "imgresize";
  imgur = makePlugin "imgur";
  imgview = makePlugin "imgview";
  ipinfo = makePlugin "ipinfo";
  kdeconnect = makePlugin "kdeconnect";
  launch = makePlugin "launch";
  mimelist = makePlugin "mimelist";
  moclyrics = makePlugin "moclyrics";
  mocq = makePlugin "mocq";
  mp3conv = makePlugin "mp3conv";
  mtpmount = makePlugin "mtpmount";
  nbak = makePlugin "nbak";
  nmount = makePlugin "nmount";
  nuke = makePlugin "nuke";
  oldbigfile = makePlugin "oldbigfile";
  openall = makePlugin "openall";
  organize = makePlugin "organize";
  pdfread = makePlugin "pdfread";
  preview-tabbed = makePlugin "preview-tabbed";
  preview-tui = makePlugin "preview-tui";
  pskill = makePlugin "pskill";
  renamer = makePlugin "renamer";
  ringtone = makePlugin "ringtone";
  rsynccp = makePlugin "rsynccp";
  splitjoin = makePlugin "splitjoin";
  suedit = makePlugin "suedit";
  togglex = makePlugin "togglex";
  umounttree = makePlugin "umounttree";
  upload = makePlugin "upload";
  wallpaper = makePlugin "wallpaper";
  x2sel = makePlugin "x2sel";
  xdgdefault = makePlugin "xdgdefault";
}
