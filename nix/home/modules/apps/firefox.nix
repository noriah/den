{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.firefox;
in
{
  options.den.apps.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {

    programs.firefox.enable = true;

    programs.firefox.policies.Preferences = {
      "app.normandy.first_run" = false;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.contentblocking.category" = "standard";
      "browser.formfill.enable" = false;
      "browser.rights.3.shown" = true;
      "browser.search.region" = "US";
      "browser.search.serpEventTelemetryCategorization.regionEnabled" = false;

      # reset these every time hm is run. fuck telemetry
      "browser.search.totalSearches" = 0;
      "browser.shell.defaultBrowserCheckCount" = 0;
      # fuck telemetry

      "browser.shell.checkDefaultBrowser" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;

      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.usage.uploadEnabled" = false;

      "devtools.everOpened" = true;

      "network.dns.disablePrefetch" = true;
      "network.predictor.enabled" = false;

      "permissions.default.camera" = 2;
      "permissions.default.desktop-notification" = 2;
      "permissions.default.geo" = 2;
      "permissions.default.microphone" = 2;
      "permissions.default.xr" = 2;

      "places.history.enabled" = false;

      "privacy.clearOnShutdown_v2.formdata" = true;
      "privacy.exposeContentTitleInWindow" = false;
      "privacy.exposeContentTitleInWindow.pbm" = false;
      "privacy.history.custom" = true;
      "sidebar.main.tools" = "history,bookmarks";
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;

      "signon.rememberSignons" = false;

      "trailhead.firstrun.didSeeAboutWelcome" = true;
    };

    programs.firefox.policies.ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "2.0@disconnect.me" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/disconnect/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };
      "search@kagi.com" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = true;
      };

    };

  };
}
