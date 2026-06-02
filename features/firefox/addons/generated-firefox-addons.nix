{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "braavos-wallet" = buildFirefoxXpiAddon {
      pname = "braavos-wallet";
      version = "4.15.2";
      addonId = "{a0c6ccfd-26a3-4df4-9729-aa036070ad29}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4634662/braavos_wallet-4.15.2.xpi";
      sha256 = "634a89e4d10f0d97283dfeae4af4318564dc4d8166ac0c2f0133b631b27fd7e9";
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
    "revoke-cash" = buildFirefoxXpiAddon {
      pname = "revoke-cash";
      version = "0.7.4";
      addonId = "webextension@revoke.cash";
      url = "https://addons.mozilla.org/firefox/downloads/file/4652742/revoke_cash-0.7.4.xpi";
      sha256 = "2cd8ce3c93063f9727f97cf3a26e62010a684ecf3bf47c9b2f6a835a7e8d4675";
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
      version = "4.3.3";
      addonId = "wallet@tonkeeper.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4624593/tonkeeper-4.3.3.xpi";
      sha256 = "48e6190cc926714599b1b6275d6c42ab4da352e3a941879f87b422edec6fc333";
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
