{ ... }:

{
  flake.homeModules.nixcord =
    { inputs, ... }:
    {
      imports = [ inputs.nixcord.homeManagerModules.nixcord ];

      programs.nixcord = {
        enable = true;
        quickCss = "\n/*removable addons*/\n@import url('https://mwittrien.github.io/BetterDiscordAddons/Themes/_res/SettingsIcons.css');\n/* @import url('https://nyri4.github.io/Discolored/main.css'); */\n@import url(\"https://warrayquipsome.github.io/Chillax/Addons/IconPackEdited.css\");\n/* @import url(\"https://warrayquipsome.github.io/Chillax/Addons/AvatarOnlyMemberList.css\"); */\n@import url(\"https://warrayquipsome.github.io/Chillax/Addons/SimpleLessLag.css\");\n@import url(\"https://discord-extensions.github.io/modern-indicators/src/source.css\");\n\n/**\n * @name midnight\n * @description A darkened discord theme.\n * @author refact0r\n * @version 1.5.0\n * @source https://github.com/refact0r/midnight-discord\n * @authorId 508863359777505290\n*/\n\n/* IMPORTANT: make sure to enable dark mode in discord settings for the theme to apply properly!! */\n\n@import url('https://refact0r.github.io/midnight-discord/midnight.css');\n\n/* change colors and variables here */\n:root {\n\t/* amount of spacing and padding */\n\t--spacing: 12px;\n\t/* radius of round corners */\n\t--roundness: 16px;\n\n\t/* color of links */\n\t--accent-1: hsl(120, 70%, 60%);\n\t/* color of unread dividers and some indicators */\n\t--accent-2: hsl(120, 70%, 50%);\n\t/* color of accented buttons */\n\t--accent-3: hsl(120, 70%, 40%);\n\t/* color of accented buttons when hovered */\n\t--accent-4: hsl(120, 70%, 30%);\n\t/* color of accented buttons when clicked */\n\t--accent-5: hsl(120, 70%, 20%);\n\n\t/* color of mentions and messages that mention you */\n\t--mention: hsla(120, 60%, 50%, 0.05);\n\t/* color of mentions and messages that mention you when hovered */\n\t--mention-hover: hsla(120, 60%, 50%, 0.1);\n\n\t/* color of bright text on colored buttons */\n\t--text-1: hsl(0, 0%, 90%);\n\t/* color of headings and important text */\n\t--text-2: hsl(0, 0%, 70%);\n\t/* color of normal text */\n\t--text-3: hsl(0, 0%, 60%);\n\t/* color of icon buttons and channels */\n\t--text-4: hsl(0, 0%, 40%);\n\t--text-5: hsl(0, 0%, 20%);\n\n\t/* color of interactive elements */\n\t--interactive-normal: hsl(0, 0%, 60%);\n\t/* color of interactive elements when hovered */\n\t--interactive-hover: hsl(0, 0%, 80%);\n\t/* color of interactive elements when selected */\n\t--interactive-selected: hsl(0, 0%, 90%);\n\n\t/* color of main background */\n\t--bg-1: hsl(0, 0%, 10%);\n\t/* color of secondary background */\n\t--bg-2: hsl(0, 0%, 12%);\n\t/* color of tertiary background (cards, input fields) */\n\t--bg-3: hsl(0, 0%, 14%);\n\t/* color of elevated elements (modals, popouts) */\n\t--bg-4: hsl(0, 0%, 16%);\n\t/* color of overlay backgrounds (backdrop) */\n\t--bg-overlay: hsla(0, 0%, 0%, 0.6);\n\n\t/* background modifier for hovered buttons */\n\t--bg-modifier-hover: hsla(0, 0%, 100%, 0.06);\n\t/* background modifier for selected buttons */\n\t--bg-modifier-selected: hsla(0, 0%, 100%, 0.09);\n\n\t/* color of borders */\n\t--border: hsl(0, 0%, 18%);\n\n\t/* scrollbar background */\n\t--scrollbar: hsl(0, 0%, 20%);\n\t/* scrollbar background when hovering */\n\t--scrollbar-hover: hsl(0, 0%, 30%);\n\n\t/* channel voice indicator colors */\n\t--channel-green: 43, 183, 106;\n\t--channel-red: 219, 59, 54;\n\t--channel-yellow: 240, 168, 32;\n}\n\n/* end of variables */\n";
        extraConfig = {
            cloud = {
              authenticated = true;
              url = "https://api.vencord.dev/";
              settingsSync = true;
              settingsSyncVersion = 1735031374378;
            };
            notifications = {
              timeout = 5000;
              position = "bottom-right";
              useNative = "not-focused";
              logLimit = 50;
            };
        };
        config = {
          autoUpdate = false;
          notifyAboutUpdates = false;
          useQuickCss = true; 
          enableReactDevtools = false;
          themeLinks = [ "https://luckfire.github.io/amoled-cord/src/amoled-cord.css" ];
          frameless = true; 
          autoUpdateNotification = false;
          transparent = true;
          disableMinSize = false;
          
          plugins = {
            betterSessions = {
              enable = true;
              backgroundCheck = true;
            };
            betterSettings = {
              enable = true;
            };
            betterRoleContext = {
              enable = true;
            };
            dontRoundMyTimestamps.enable = true;
            consoleJanitor.enable = true;
            friendsSince.enable = true;
            mentionAvatars = {
              enable = true;
              showAtSymbol = false;
            };
            XSOverlay.enable = true;

            alwaysAnimate.enable = true;
            alwaysTrust = {
              enable = true;
              domain = true;
              file = true;
            };
            anonymiseFileNames = {
              enable = true;
              method = "consistent";
              randomisedLength = 7;
              consistent = "file";
              anonymiseByDefault = true;
            };
            betterGifAltText.enable = true;
            betterRoleDot = {
              enable = true;
              bothStyles = false;
              copyRoleColorInProfilePopout = false;
            };
            blurNSFW = {
              enable = true;
              blurAmount = 10;
            };
            callTimer = {
              enable = false;
              format = "";
            };
            chatInputButtonAPI.enable = true;
            clearURLs.enable = true;
            commandsAPI.enable = true;
            crashHandler = {
              enable = true;
              attemptToPreventCrashes = true;
              attemptToNavigateToHome = false;
            };
            decor.enable = true;
            disableCallIdle.enable = true;
            emoteCloner.enable = true;
            experiments = {
              enable = true;
              toolbarDevMenu = false;
            };
            fakeProfileThemes = {
              enable = true;
              nitroFirst = false;
            };
            favoriteEmojiFirst.enable = true;
            favoriteGifSearch = {
              enable = true;
              searchOption = "hostandpath";
            };
            fixSpotifyEmbeds = {
              enable = true;
              volume = 10.0;
            };
            fixYoutubeEmbeds.enable = true;
            forceOwnerCrown.enable = true;
            gifPaste.enable = true;
            imageZoom = {
              enable = true;
              saveZoomValues = true;
              invertScroll = true;
              zoom = 1.555555570272753;
              size = 100.0;
              zoomSpeed = 0.5;
              nearestNeighbour = false;
              square = false;
            };
            memberCount = {
              enable = true;
              memberList = true;
              toolTip = true;
            };
            memberListDecoratorsAPI.enable = true;
            messageAccessoriesAPI.enable = true;
            messageClickActions = {
              enable = true;
              requireModifier = false;
              enableDoubleClickToReply = true;
              enableDoubleClickToEdit = true;
            };
            messageDecorationsAPI.enable = true;
            messageEventsAPI.enable = true;
            messageLinkEmbeds = {
              enable = true;
              automodEmbeds = "never";
              listMode = "blacklist";
              idList = "";
            };
            messageLogger = {
              enable = true;
              deleteStyle = "text";
              ignoreBots = true;
              ignoreSelf = true;
              ignoreUsers = "";
              ignoreChannels = "";
              ignoreGuilds = "";
              logEdits = true;
              logDeletes = true;
              collapseDeleted = false;
              inlineEdits = true;
            };
            messagePopoverAPI.enable = true;
            messageUpdaterAPI.enable = true;
            moreUserTags = {
              enable = true;
              tagSettings = {
                webhook = {
                  text = "Webhook";
                  showInChat = true;
                  showInNotChat = true;
                };
                owner = {
                  text = "Owner";
                  showInChat = true;
                  showInNotChat = true;
                };
                administrator = {
                  text = "Admin";
                  showInChat = true;
                  showInNotChat = true;
                };
                moderatorStaff = {
                  text = "Staff";
                  showInChat = true;
                  showInNotChat = true;
                };
                moderator = {
                  text = "Mod";
                  showInChat = true;
                  showInNotChat = true;
                };
                voiceModerator = {
                  text = "VC Mod";
                  showInChat = true;
                  showInNotChat = true;
                };
                chatModerator = {
                  text = "Chat Mod";
                  showInChat = true;
                  showInNotChat = true;
                };
              };
            };
            noBlockedMessages = {
              enable = true;
              ignoreBlockedMessages = false;
            };
            noF1.enable = true;
            noReplyMention = {
              enable = true;
              userList = "1234567890123445,1234567890123445";
              shouldPingListed = true;
              inverseShiftReply = false;
            };
            noSystemBadge.enable = true;
            noTrack = {
              enable = true;
              disableAnalytics = true;
            };
            noUnblockToJump.enable = true;
            normalizeMessageLinks.enable = true;
            onePingPerDM = {
              enable = true;
              channelToAffect = "both_dms";
              allowMentions = false;
              allowEveryone = false;
            };
            openInApp = {
              enable = true;
              spotify = true;
              steam = true;
              epic = true;
              tidal = true;
              itunes = true;
            };
            permissionsViewer = {
              enable = true;
              permissionsSortOrder = "highestRole";
              defaultPermissionsDropdownState = false;
            };
            pictureInPicture.enable = true;
            pinDMs = {
              enable = true;
              pinOrder = "mostRecent";
              dmSectioncollapsed = false;
            };
            platformIndicators = {
              enable = false;
              lists = false;
              badges = true;
              messages = false;
              colorMobileIndicator = true;
            };
            quickMention.enable = true;
            relationshipNotifier = {
              enable = true;
              notices = true;
              offlineRemovals = true;
              friends = true;
              friendRequestCancels = true;
              servers = true;
              groups = true;
            };
            reverseImageSearch.enable = true;
            serverInfo.enable = true;
            serverListAPI.enable = true;
            settings = {
              enable = true;
              settingsLocation = "aboveActivity";
            };
            shikiCodeblocks = {
              enable = true;
              theme = "https://raw.githubusercontent.com/millsp/material-candy/master/material-candy.json";
              tryHljs = "SECONDARY";
              useDevIcon = "GREYSCALE";
              bgOpacity = 100.0;
            };
            silentTyping = {
              enable = true;
              showIcon = false;
              isEnabled = true;
              contextMenu = true;
            };
            spotifyControls = {
              enable = true;
              hoverControls = true;
              useSpotifyUris = true;
            };
            spotifyCrack = {
              enable = true;
              noSpotifyAutoPause = true;
              keepSpotifyActivityOnIdle = false;
            };
            summaries = {
              enable = true;
              summaryExpiryThresholdDays = 3;
            };
            supportHelper.enable = true;
            translate = {
              enable = true;
              autoTranslate = false;
              showChatBarButton = true;
            };
            typingIndicator = {
              enable = true;
              includeCurrentChannel = true;
              includeMutedChannels = false;
              includeBlockedUsers = false;
              indicatorMode = "animatedDots";
            };
            typingTweaks = {
              enable = true;
              showAvatars = true;
              showRoleColors = true;
              alternativeFormatting = true;
            };
            USRBG = {
              enable = true;
              voiceBackground = true;
              nitroFirst = true;
            };
            unindent.enable = true;
            userSettingsAPI.enable = true;
            userVoiceShow = {
              enable = true;
              showInUserProfileModal = true;
              showVoiceChannelSectionHeader = true;
              showInMemberList = true;
              showInMessages = true;
            };
            validReply.enable = true;
            viewIcons = {
              enable = true;
              format = "webp";
              imgSize = 1024;
            };
            volumeBooster = {
              enable = true;
              multiplier = 2;
            };
            webKeybinds.enable = true;
            webScreenShareFixes.enable = true;
            youtubeAdblock.enable = true;
            petpet.enable = true;
          };
        };
      };
    };
}
