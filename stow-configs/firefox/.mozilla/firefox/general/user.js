// capture configuration changes:
//
// TODO: move to devshell
// ``` sh
// cd ~/.mozilla/firefox/general
// cp prefs.js prefs-orig.js
// # make configuration change
// diff prefs.js prefs-orig.js
// ```

// Search Engines
user_pref("browser.urlbar.placeholderName", "SearXNG Belgium");
user_pref("browser.urlbar.placeholderName.private", "SearXNG Belgium");

// History
// Cookies: Add Exception: CTRL-I > Permissions > Set cookies > Allow
user_pref("privacy.history.custom", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.sanitize.pending", "[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}},{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"formdata\",\"sessions\"],\"options\":{}}]");

// Enhanced Tracking Protection: Strict
user_pref("browser.contentblocking.category", "strict");
user_pref("network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation", true);
user_pref("privacy.annotate_channels.strict_list.enabled", true);
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.query_stripping.enabled", true);
user_pref("privacy.query_stripping.enabled.pbmode", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);

// DNS-over-HTTPS
user_pref("doh-rollout.disable-heuristics", true);
user_pref("network.trr.mode", 3);
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");

// Data Collection
user_pref("browser.discovery.enabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);

// HTTPS-Only
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Bookmarks.
// CAUTION: overrides existing bookmarks
user_pref("browser.bookmarks.file", "~/.local/share/firefox/bookmarks.general.html");
user_pref("browser.places.importBookmarksHTML", true);

// UI
user_pref("browser.download.autohideButton", false);
// With ShyFox
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_3c078156-979c-498b-8990-85f7987dd929_-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"_e58d3966-3d76-4cd9-8552-1582fbc800c1_-browser-action\",\"browserpass_maximbaz_com-browser-action\",\"_04188724-64d3-497b-a4fd-7caffe6eab29_-browser-action\",\"_1c5e4c6f-5530-49a3-b216-31ce7d744db0_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action\",\"_ublacklist-browser-action\",\"addon_fastforward_team-browser-action\",\"_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action\",\"_7c42eea1-b3e4-4be4-a56f-82a5852b12dc_-browser-action\",\"_a0c6ccfd-26a3-4df4-9729-aa036070ad29_-browser-action\",\"atbc_easonwong-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"webextension_revoke_cash-browser-action\",\"ff2mpv_yossarian_net-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"userchrome-toggle_joolee_nl-browser-action\",\"urlbar-container\",\"customizableui-special-spring2\",\"zoom-controls\",\"unified-extensions-button\",\"userchrome-toggle-extended_n2ezr_ru-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"ublock0_raymondhill_net-browser-action\",\"simple-translate_sienori-browser-action\",\"idcac-pub_guus_ninja-browser-action\",\"profile-switcher-ff_nd_ax-browser-action\",\"webextension_metamask_io-browser-action\",\"_b12c8974-64dd-4022-8208-ed48e6979360_-browser-action\",\"wallet_tonkeeper_com-browser-action\",\"customizableui-special-spring11\",\"privatebrowsing-button\",\"downloads-button\",\"history-panelmenu\",\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"_e58d3966-3d76-4cd9-8552-1582fbc800c1_-browser-action\",\"browserpass_maximbaz_com-browser-action\",\"simple-translate_sienori-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_04188724-64d3-497b-a4fd-7caffe6eab29_-browser-action\",\"_1c5e4c6f-5530-49a3-b216-31ce7d744db0_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action\",\"_ublacklist-browser-action\",\"addon_fastforward_team-browser-action\",\"idcac-pub_guus_ninja-browser-action\",\"webextension_metamask_io-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action\",\"profile-switcher-ff_nd_ax-browser-action\",\"_7c42eea1-b3e4-4be4-a56f-82a5852b12dc_-browser-action\",\"_b12c8974-64dd-4022-8208-ed48e6979360_-browser-action\",\"wallet_tonkeeper_com-browser-action\",\"_a0c6ccfd-26a3-4df4-9729-aa036070ad29_-browser-action\",\"_3c078156-979c-498b-8990-85f7987dd929_-browser-action\",\"atbc_easonwong-browser-action\",\"userchrome-toggle_joolee_nl-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"webextension_revoke_cash-browser-action\",\"ff2mpv_yossarian_net-browser-action\",\"userchrome-toggle-extended_n2ezr_ru-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"unified-extensions-area\",\"toolbar-menubar\",\"TabsToolbar\",\"vertical-tabs\"],\"currentVersion\":20,\"newElementCount\":12}");
// ShyFox setup
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("sidebar.revamp", false);
user_pref("svg.context-properties.content.enabled", true);
user_pref("layout.css.has-selector.enabled", true);
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.trimURLs", true);
user_pref("widget.gtk.rounded-bottom-corners.enabled", true);
user_pref("widget.gtk.ignore-bogus-leave-notify", 1);

// Recommend extension as use browse
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
// Recommend features as use browse
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
// On Startup: open previous windows and tabs
user_pref("browser.startup.page", 3);
// Ask to remember passwords
user_pref("signon.rememberSignons", false);
// Remember form fills
user_pref("browser.formfill.enable", false);
// Firefox Home Page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

// Misc
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.shell.checkDefaultBrowser", false);
