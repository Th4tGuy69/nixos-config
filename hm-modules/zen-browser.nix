{
  inputs,
  system,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;

    profiles."That Guy" =
      let
        containers = {
          Personal = {
            color = "toolbar";
            icon = "circle";
            id = 1;
          };
          Work = {
            color = "toolbar";
            icon = "circle";
            id = 2;
          };
        };

        spaces = {
          Personal = {
            id = "f87a6e79-da7d-4474-9d6e-161ef88e2563";
            position = 1000;
            container = containers.Personal.id;
          };
          Work = {
            id = "035e231b-8e62-417d-88a1-527c2604c1c6";
            position = 2000;
            container = containers.Work.id;
          };
        };

        pins = {
          # Personal
          Youtube = {
            id = "e0fea1a2-7a1d-4bed-a9da-3716a532e229";
            container = containers.Personal.id;
            url = "https://www.youtube.com/";
            position = 200;
          };
          Subscriptions = {
            id = "04deb0d4-3fe4-4288-89e5-d84608fcd0e8";
            container = containers.Personal.id;
            url = "https://www.youtube.com/feed/subscriptions";
            editedTitle = true;
            position = 201;
          };
          # Work
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          adnauseam
          bitwarden
          consent-o-matic
          darkreader
          decentraleyes
          pay-by-privacy
          return-youtube-dislikes
          sponsorblock
          wappalyzer
        ];

        search = {
          force = true;
          default = "searxng";
          engines = {
            searxng = {
              name = "SearXNG";
              definedAliases = [ "@searxng" ];
              urls = [
                {
                  template = "https://search.that-guy.dev/search?q={searchTerms}&language=en&safesearch=0&categories=general";
                }
              ];
              iconMapObj."20" = "https://docs.searxng.org/_static/searxng-wordmark.svg";
            };
            nixpkgs = {
              name = "Nix Packages";
              definedAliases = [ "@nixpkgs" ];
              urls = [
                {
                  template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            nixOptions = {
              name = "Nix Options";
              definedAliases = [ "@nixoptions" ];
              urls = [
                {
                  template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            homeManagerOptions = {
              name = "Home Manager Options";
              definedAliases = [ "@homeoptions" ];
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
                }
              ];
              iconMapObj."20" = "https://nix-community.org/nix-community-logo.svg";
            };
          };
        };
      in
      {
        containersForce = true;
        pinsForce = true;
        spacesForce = true;
        inherit
          containers
          extensions
          pins
          search
          spaces
          ;
      };

    policies = {
      # Default
      DisableAppUpdate = true;
      DisableTelemetry = true;
      # Other
      HttpsOnlyMode = true;
      SSLVersionMin = "tls1.2";
      SSLVersionMax = "tls1.3";
      PostQuantumKeyAgreementEnabled = true;
      DisableEncryptedClientHello = false;
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
      };
      NetworkPrediction = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
      };
      DisableFirefoxStudies = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
      };
      GenerativeAI.Enabled = false;
      VisualSearchEnabled = false;
      DisablePocket = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      DisableFormHistory = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      Cookies = {
        AcceptThirdParty = false;
        Behavior = "reject-tracker";
      };
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        History = false;
        Sessions = false;
      };
      DisableSecurityBypass = true;
      PDFjs.EnableScripting = false;
      StartDownloadsInTempDirectory = true;
      SearchEngines.PreventInstalls = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
    };
  };

  xdg.mimeApps =
    let
      value =
        let
          zen-browser = inputs.zen-browser.packages.${system}.beta;
        in
        zen-browser.meta.desktopFileName;

      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name value;
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };
}
