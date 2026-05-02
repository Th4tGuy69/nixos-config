{ ... }:

{
  flake.homeModules.zen-browser =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;

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

            mods = [
              "f4866f39-cfd6-4498-ab92-54213b8279dc" # Animations Plus
              "c5f7fb68-cc75-4df0-8b02-dc9ee13aa773" # Audio TabIcon Plus
              "4a222d82-2803-4ed2-a390-90abfce4f195" # Back Fwd Always Hidden
              # "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab Panel
              # "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
              "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
              "5c4d7772-d963-4672-ab03-e9d541438881" # Bigger Mute Button
              "ea1a5ace-f698-4b45-ab88-6e8bd3a563f0" # Bookmark Toolbar Tweaks
              "a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec" # Cleaned URL bar
              "5bb07b6e-c89f-4f4a-a0ed-e483cc535594" # Custom MenuButton
              "e74cb40a-f3b8-445a-9826-1b1b6e41b846" # Custom uiFont
              "2bbe4f0d-f7af-460b-86de-cda893357813" # Customized Popup
              "13696593-837d-464d-adf4-ff13bd0e0545" # Download BG
              # "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
              "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
              # "83a641f7-eca9-4c0f-91af-45627bef0539" # Floating URLbar
              "4ce2b68c-84f1-4296-b145-4e590ad7a19e" # Floating findbar
              # "67b12475-1c26-4d13-9156-297383ed8dbf" # Floating toolbar
              "5a007026-0801-4a5d-9740-f17dc1c3ff21" # Hide Window Buttons
              "1e86cf37-a127-4f24-b919-d265b5ce29a0" # Lean
              "6f11c932-b992-433e-8c80-56a613cc511e" # Left close button
              # "ab9b529c-63d6-48c0-a59a-4a407c5c3129" # Minimal sidebar
              "11d685eb-4515-4045-864b-0a50589f8a4d" # Monochrome
              "d7076c31-f6c1-4f28-b2e8-15b95f5a3d6f" # No Search Shortcut Icons
              "c45c4894-d6bd-47fc-997a-0c4d015334f1" # No pinned tab reset btn
              "4596d8f9-f0b7-4aeb-aa92-851222dc1888" # Only Close On Hover
              "599a1599-e6ab-4749-ab22-de533860de2c" # Pimp your PiP
              "58649066-2b6f-4a5b-af6d-c3d21d16fc00" # Private Mode Highlighting
              "680424a8-a818-406b-98c5-7726214e2a9f" # Remove Browser Padding
              "0d218357-d5be-48f1-bbc0-5e7cb2d2e11f" # Revitalized devtools
              "20e8cc78-3dac-4db0-81a4-814672fb50af" # Right Side Glance Buttons
              # "5941aefd-67b0-453d-9b62-9071a31cbb0d" # Smaller Compact Mode
              "d93e67f8-e5e1-401e-9b82-f9d5bab231e6" # Super Url Bar
              # "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
              "180d9426-a020-4bd7-98ec-63f957291119" # TitleBarButton UI Tweaks
              "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
              # "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
              "81fcd6b3-f014-4796-988f-6c3cb3874db8" # Zen Context Menu
              "dd4f5461-1564-4e56-9f9d-f81e3c18f93c" # Zen Sidebar At Right Side
            ];

            pins = {
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

            settings = {
              ### Firefox Settings

              "general.autoScroll" = true;

              ### Zen Settings ###

              # Tabs
              "zen.tabs.show-newtab-under" = false;
              "zen.tabs.show-newtab-vertical" = false;
              "zen.tab-unloader.timeout-minutes" = 5;

              # Theme / Appearance
              "zen.theme.accent-color" = "#a5a5a5";
              "zen.theme.color-prefs.amoled" = true;
              "zen.theme.content-element-separation" = 0;
              "zen.theme.toolbar-themed" = false;
              "zen.themes.disable-all" = false;

              # Compact mode
              "zen.view.compact" = true;
              "zen.view.compact.enable-at-startup" = true;
              "zen.view.compact.should-enable-at-startup" = true;

              # View / Layout
              "zen.view.show-bottom-border" = true;
              "zen.view.sidebar-expanded.on-hover" = false;
              "zen.view.use-single-toolbar" = false;
              "zen.view.window.scheme" = 0;

              # Workspaces
              "zen.workspaces.separate-essentials" = false;
              "zen.workspaces.show-icon-strip" = false;

              # Welcome / onboarding (suppresses setup screens)
              "zen.welcome-screen.seen" = true;

              # Sidebar
              "zen.sidebar.floating" = false;
              "zen.site-data-panel.show-callout" = false;

              # Glance
              "zen.glance.activation-method" = "ctrl";

              # Pinned tabs
              "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-position" = true; # check exact value in your diff
            };
          in
          {
            containersForce = true;
            pinsForce = true;
            spacesForce = true;
            inherit
              containers
              extensions
              mods
              pins
              search
              settings
              spaces
              ;
          };

        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
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
    };
}
