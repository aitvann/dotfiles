{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "braavos-wallet" = buildFirefoxXpiAddon {
      pname = "braavos-wallet";
      version = "3.93.1";
      addonId = "{a0c6ccfd-26a3-4df4-9729-aa036070ad29}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4451004/braavos_wallet-3.93.1.xpi";
      sha256 = "0090413905d86be748ad868fb93a34efba09c5d44319f2af42c8980dacf401e8";
      meta = with lib;
      {
        homepage = "https://www.braavos.app";
        description = "Most advanced and user-friendly Starknet wallet, featuring 2FA / 3FA security and enhanced DeFi capabilities.";
        mozPermissions = [
          "storage"
          "alarms"
          "notifications"
          "http://localhost/*"
          "http://127.0.0.1/*"
          "http://0.0.0.0/*"
          "https://*/*"
        ];
        platforms = platforms.all;
      };
    };
    "joinfire" = buildFirefoxXpiAddon {
      pname = "joinfire";
      version = "0.0.2.25";
      addonId = "{b12c8974-64dd-4022-8208-ed48e6979360}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4091167/joinfire-0.0.2.25.xpi";
      sha256 = "7ad4ccddcc00404046db779d376fecd4a46a734783eb6e5c538198cf461c269c";
      meta = with lib;
      {
        description = "Fire is a tool that makes Web3 simple, by showing you what happens at the smart contract level in a human-readable format.";
        mozPermissions = [
          "storage"
          "tabs"
          "activeTab"
          "<all_urls>"
          "http://*/*"
          "https://*/*"
        ];
        platforms = platforms.all;
      };
    };
    "phantom-app" = buildFirefoxXpiAddon {
      pname = "phantom-app";
      version = "25.3.1";
      addonId = "{7c42eea1-b3e4-4be4-a56f-82a5852b12dc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4428642/phantom_app-25.3.1.xpi";
      sha256 = "cc4d97e9d90b8938882eef70f17c7ff6bf65988b84f51edd93e29f70adc58e16";
      meta = with lib;
      {
        description = "A crypto wallet reimagined for DeFi &amp; NFTs";
        license = licenses.mit;
        mozPermissions = [
          "activeTab"
          "alarms"
          "identity"
          "storage"
          "scripting"
          "tabs"
          "webRequest"
          "unlimitedStorage"
        ];
        platforms = platforms.all;
      };
    };
    "revoke-cash" = buildFirefoxXpiAddon {
      pname = "revoke-cash";
      version = "0.6.6";
      addonId = "webextension@revoke.cash";
      url = "https://addons.mozilla.org/firefox/downloads/file/4437589/revoke_cash-0.6.6.xpi";
      sha256 = "8bad64d25a0f5bdb9addde2168694596c5b470a2156021757045d210afae2274";
      meta = with lib;
      {
        homepage = "https://revoke.cash";
        description = "The Revoke.cash browser extension helps protect you from common crypto scams.";
        license = licenses.mit;
        mozPermissions = [ "<all_urls>" "storage" ];
        platforms = platforms.all;
      };
    };
    "tonkeeper" = buildFirefoxXpiAddon {
      pname = "tonkeeper";
      version = "3.26.1";
      addonId = "wallet@tonkeeper.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4396187/tonkeeper-3.26.1.xpi";
      sha256 = "9c961e4cac41b923af58b65dd872c3f6858a807c2f29318df6e1fdc6012a2e86";
      meta = with lib;
      {
        homepage = "https://tonkeeper.com/";
        description = "Tonkeeper is the easiest way to store, send, and receive Toncoin on The Open Network, which is a powerful new blockchain that offers unprecedented transaction speeds and throughput while offering a robust programming environment for applications.";
        license = licenses.mit;
        mozPermissions = [
          "storage"
          "unlimitedStorage"
          "clipboardWrite"
          "activeTab"
          "file://*/*"
          "http://*/*"
          "https://*/*"
        ];
        platforms = platforms.all;
      };
    };
  }