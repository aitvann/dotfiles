{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "braavos-wallet" = buildFirefoxXpiAddon {
      pname = "braavos-wallet";
      version = "4.9.2";
      addonId = "{a0c6ccfd-26a3-4df4-9729-aa036070ad29}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4556880/braavos_wallet-4.9.2.xpi";
      sha256 = "b16af339509a75cade7af6979fea88e3b5364a98f6e3382e50c17ca2ec6adae5";
      meta = with lib;
      {
        homepage = "https://www.braavos.app";
        description = "Most advanced and user-friendly Starknet wallet, featuring 2FA / 3FA security and enhanced DeFi capabilities.";
        mozPermissions = [
          "storage"
          "alarms"
          "notifications"
          "<all_urls>"
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
    "new-minecraft-wiki-redirect" = buildFirefoxXpiAddon {
      pname = "new-minecraft-wiki-redirect";
      version = "1.6.0";
      addonId = "new-minecraft-wiki-redirect@lordpipe";
      url = "https://addons.mozilla.org/firefox/downloads/file/4395229/new_minecraft_wiki_redirect-1.6.0.xpi";
      sha256 = "51e81d519483a93ea5d3d27ac4772b96940f20514c2f162a701a4d3610e18a7d";
      meta = with lib;
      {
        homepage = "https://github.com/lordofpipes/new-minecraft-wiki-redirect";
        description = "Automatically redirect to the new non-Fandom Minecraft wiki.";
        license = licenses.gpl3;
        mozPermissions = [ "declarativeNetRequest" "storage" ];
        platforms = platforms.all;
      };
    };
    "phantom-app" = buildFirefoxXpiAddon {
      pname = "phantom-app";
      version = "25.16.0";
      addonId = "{7c42eea1-b3e4-4be4-a56f-82a5852b12dc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4488518/phantom_app-25.16.0.xpi";
      sha256 = "1de1b9bf831a572056748638e93b4b89e07dffcc25c0f71f5f5c198546c3f53e";
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
    "proxy-toggle" = buildFirefoxXpiAddon {
      pname = "proxy-toggle";
      version = "1.2.1";
      addonId = "{0c3ab5c8-57ac-4ad8-9dd1-ee331517884d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3405365/proxy_toggle-1.2.1.xpi";
      sha256 = "467f2567f03ecbc503f931d39d5cd8a144b3279f34f0569c6796303b2013ea52";
      meta = with lib;
      {
        description = "Toggle between direct connection and a single proxy server via a toolbar icon.";
        license = licenses.mit;
        mozPermissions = [
          "storage"
          "proxy"
          "<all_urls>"
          "webRequest"
          "webRequestBlocking"
        ];
        platforms = platforms.all;
      };
    };
    "revoke-cash" = buildFirefoxXpiAddon {
      pname = "revoke-cash";
      version = "0.7.0";
      addonId = "webextension@revoke.cash";
      url = "https://addons.mozilla.org/firefox/downloads/file/4536973/revoke_cash-0.7.0.xpi";
      sha256 = "b6e209d24d7352bd27684a6574ddd495ea45802e5553abbb40241e586988b250";
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
      version = "4.1.2";
      addonId = "wallet@tonkeeper.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4545318/tonkeeper-4.1.2.xpi";
      sha256 = "1018941ad2a2670085d8ba5c0779396ba7ed44b0ac595cc69d0befc8400a6885";
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