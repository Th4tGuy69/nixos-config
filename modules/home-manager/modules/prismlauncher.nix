{ ... }:

{
  flake.homeModules.prismlauncher =
    { pkgs, ... }:
    {
      home.file.".local/share/PrismLauncher/themes" = {
        source = pkgs.fetchzip {
          url = "https://github.com/PrismLauncher/Themes/releases/latest/download/Amoled-theme.zip";
          sha256 = "sha256-rjGTYC7nq9fTT1yVQPaD+aRBCHXnhjfG260PNNpeTrU=";
        };
      };

      programs.prismlauncher = {
        enable = true;

        package =
          with pkgs;
          (prismlauncher.override {
            jdks = [
              graalvmPackages.graalvm-ce
              zulu8
              zulu17
              zulu
            ];
          });

        settings = {
          ApplicationTheme = "Amoled";
          AutoCloseConsole = false;
          AutomaticJavaDownload = false;
          AutomaticJavaSwitch = true;
          BackgroundCat = "rory-flat";
          CatFit = "fit";
          CatOpacity = 100;
          CentralModsDir = "mods";
          CloseAfterLaunch = false;
          ConfigVersion = "1.3";
          ConsoleFont = "FiraCode Nerd Font Mono";
          ConsoleFontSize = 11;
          ConsoleMaxLines = 100000;
          ConsoleOverflowStop = true;
          DownloadsDirWatchRecursive = false;
          EnableFeralGamemode = true;
          EnableMangoHud = false;
          FallbackMRBlockedMods = 2;
          FlameKeyOverride = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
          IconTheme = "flat_white";
          IconsDir = "icons";
          IgnoreJavaCompatibility = false;
          IgnoreJavaWizard = false;
          InstRenamingMode = "AskEverytime";
          InstSortMode = "Name";
          InstanceDir = "instances";
          JavaArchitecture = 64;
          JavaDir = "java";
          JavaRealArchitecture = "amd64";
          JavaVendor = "Azul Systems, Inc.";
          Language = "en_US";
          LaunchMaximized = false;
          LowMemWarning = true;
          MaxMemAlloc = 12288;
          MenuBarInsteadOfToolBar = false;
          MinMemAlloc = 512;
          MinecraftWinHeight = 480;
          MinecraftWinWidth = 854;
          ModDependenciesDisabled = false;
          ModMetadataDisabled = false;
          ModDownloadGeometry = false;
          MoveModsFromDownloadsDir = false;
          NumberOfConcurrentDownloads = 6;
          NumberOfConcurrentTasks = 10;
          NumberOfManualRetries = 1;
          OnlineFixes = false;
          PastebinType = 3;
          PermGen = 128;
          ProxyAddr = "127.0.0.1";
          ProxyPort = 8080;
          ProxyType = "Default";
          QuitAfterGameStop = false;
          RecordGameTime = true;
          RequestTimeout = 60;
          SelectedInstance = "1.21.1";
          ShowConsole = false;
          ShowConsoleOnError = true;
          ShowGameTime = true;
          ShowGameTimeWithoutDays = false;
          ShowGlobalGameTime = true;
          ShowModIncompat = true;
          SkinsDir = "skins";
          SkipModpackUpdatePrompt = false;
          StatusBarVisible = true;
          TheCat = false;
          ToolbarsLocked = true;
          UseDiscreteGpu = false;
          UseNativeGLFW = true;
          UseNativeOpenAL = false;
          UseZink = false;
          UserAskedAboutAutomaticJavaDownload = true;
        };
      };
    };
}
