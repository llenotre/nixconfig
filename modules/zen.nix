{ zen-browser, username, ... }:
{
  home-manager.users.${username} = {
    imports = [ zen-browser.homeModules.beta ];

    # Required for the mimeapps.list handler associations that
    # `setAsDefaultBrowser` declares to actually be written out
    xdg.mimeApps.enable = true;

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      policies = {
        DontCheckDefaultBrowser = true;
        Permissions.Notifications.BlockNewRequests = true;
        # Passwords are handled by Proton Pass
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        ExtensionSettings =
          let
            fromAddons = slug: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
              installation_mode = "force_installed";
            };
          in
          {
            "uBlock0@raymondhill.net" = fromAddons "ublock-origin";
            "sponsorBlocker@ajay.app" = fromAddons "sponsorblock";
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = fromAddons "proton-pass";
          };
      };
      profiles.default = {
        settings = {
          # Skip the onboarding flow
          "zen.welcome-screen.seen" = true;
          "browser.aboutwelcome.enabled" = false;
          # Translation stays available from the menu
          "browser.translations.automaticallyPopup" = false;
          "signon.autofillForms" = false;
        };
        search = {
          force = true;
          default = "qwant";
        };
      };
    };
  };
}
