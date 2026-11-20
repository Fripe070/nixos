{ pkgs, identity, ... }:
{
  home-manager.users.${identity.username} = { ... }: {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        Homepage = {
          URL = "https://newtab.fripe.dev/";
          StartPage = "homepage";
        };
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false; # passwords live in Bitwarden

        ExtensionSettings =
          let
            amo = slug: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
              installation_mode = "normal_installed";
            };
          in
          {
            "uBlock0@raymondhill.net" = amo "ublock-origin";
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = amo "bitwarden-password-manager";
            "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = amo "violentmonkey";
          };
      };

      profiles.default = {
        isDefault = true;
        # Adopt the existing profile so history, cookies, containers etc. are kept
        path = "v0lh8n2j.default";

        settings = {
          "browser.startup.homepage" = "https://newtab.fripe.dev/";
          "browser.startup.page" = 1; # open homepage on launch
          "sidebar.verticalTabs" = true;
          "xpinstall.signatures.required" = false; # Allow unsigned/custom extensions
          "signon.rememberSignons" = false;
          "browser.translations.neverTranslateLanguages" = "sv";
        };

        search = {
          force = true;
          default = "ddg";
        };
      };
    };
  };
}
