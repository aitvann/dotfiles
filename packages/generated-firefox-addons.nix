{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "braavos-wallet" = buildFirefoxXpiAddon {
      pname = "braavos-wallet";
      version = "3.65.1";
      addonId = "{a0c6ccfd-26a3-4df4-9729-aa036070ad29}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4324886/braavos_wallet-3.65.1.xpi";
      sha256 = "dac897387cb19bb488e7b1d4c0b36a923a2de8c83f4deca8255aede118dd4500";
      meta = with lib;
      {
        homepage = "https://www.braavos.app";
        description = "The Secure and User-Friendly Smart Wallet for Starknet.";
        mozPermissions = [
          "storage"
          "alarms"
          "notifications"
          "http://localhost/*"
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
      version = "24.11.0";
      addonId = "{7c42eea1-b3e4-4be4-a56f-82a5852b12dc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4309595/phantom_app-24.11.0.xpi";
      sha256 = "7ce3fefc25cc9a10c6cadf495eeb2f9729d6511d51431f464ee38ee6e28b351f";
      meta = with lib;
      {
        description = "A crypto wallet reimagined for DeFi &amp; NFTs";
        license = licenses.mit;
        mozPermissions = [
          "storage"
          "unlimitedStorage"
          "activeTab"
          "alarms"
          "tabs"
          "http://*/*"
          "https://*/*"
          "file://*/*"
        ];
        platforms = platforms.all;
      };
    };
    "revoke-cash" = buildFirefoxXpiAddon {
      pname = "revoke-cash";
      version = "0.6.1";
      addonId = "webextension@revoke.cash";
      url = "https://addons.mozilla.org/firefox/downloads/file/4319456/revoke_cash-0.6.1.xpi";
      sha256 = "217e3f08da030e57c05d10c72cec4909c0e43d8bd60f12c08c0fac8cf9c66541";
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
      version = "3.17.0";
      addonId = "wallet@tonkeeper.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4323531/tonkeeper-3.17.0.xpi";
      sha256 = "086a7c78a4c608e88033c903dc07e511f60f58bb05c0970145ee403d83746000";
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