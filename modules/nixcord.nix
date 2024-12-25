{ ... }:

{
  programs.nixcord = {
    enable = true;  # enable Nixcord. Also installs discord package
    quickCss = "\n/*removable addons*/\n@import url('https://mwittrien.github.io/BetterDiscordAddons/Themes/_res/SettingsIcons.css');\n/* @import url('https://nyri4.github.io/Discolored/main.css'); */\n@import url(\"https://warrayquipsome.github.io/Chillax/Addons/IconPackEdited.css\");\n/* @import url(\"https://warrayquipsome.github.io/Chillax/Addons/AvatarOnlyMemberList.css\"); */\n@import url(\"https://warrayquipsome.github.io/Chillax/Addons/SimpleLessLag.css\");\n@import url(\"https://discord-extensions.github.io/modern-indicators/src/source.css\");\n\n/**\n * @name midnight\n * @description A darkened discord theme.\n * @author refact0r\n * @version 1.5.0\n * @source https://github.com/refact0r/midnight-discord\n * @authorId 508863359777505290\n*/\n\n/* IMPORTANT: make sure to enable dark mode in discord settings for the theme to apply properly!! */\n\n@import url('https://refact0r.github.io/midnight-discord/midnight.css');\n\n/* change colors and variables here */\n:root {\n\t/* amount of spacing and padding */\n\t--spacing: 12px;\n\t/* radius of round corners */\n\t--roundness: 16px;\n\n\t/* color of links */\n\t--accent-1: hsl(120, 70%, 60%);\n\t/* color of unread dividers and some indicators */\n\t--accent-2: hsl(120, 70%, 50%);\n\t/* color of accented buttons */\n\t--accent-3: hsl(120, 70%, 40%);\n\t/* color of accented buttons when hovered */\n\t--accent-4: hsl(120, 70%, 30%);\n\t/* color of accented buttons when clicked */\n\t--accent-5: hsl(120, 70%, 20%);\n\n\t/* color of mentions and messages that mention you */\n\t--mention: hsla(120, 60%, 50%, 0.05);\n\t/* color of mentions and messages that mention you when hovered */\n\t--mention-hover: hsla(120, 60%, 50%, 0.1);\n\n\t/* color of bright text on colored buttons */\n\t--text-1: hsl(0, 0%, 90%);\n\t/* color of headings and important text */\n\t--text-2: hsl(0, 0%, 70%);\n\t/* color of normal text */\n\t--text-3: hsl(0, 0%, 60%);\n\t/* color of icon buttons and channels */\n\t--text-4: hsl(0, 0%, 40%);\n\t/* color of muted channels/chats and timestamps */\n\t--text-5: hsl(0, 0%, 24%);\n\n\t/* color of dark buttons when clicked */\n\t--bg-1: hsl(0, 0%, 8%);\n\t/* color of dark buttons */\n\t--bg-2: hsl(0, 0%, 7%);\n\t/* color of spacing around panels and secondary elements */\n\t--bg-3: hsl(0, 0%, 0%);\n\t/* main background color */\n\t--bg-4: hsl(0, 0%, 5%);\n\n\t/* color of channels and icon buttons when hovered */\n\t--hover: hsla(160, 0%, 40%, 0.1);\n\t/* color of channels and icon buttons when clicked or selected */\n\t--active: hsla(150, 0%, 40%, 0.2);\n\t/* color of messages when hovered */\n\t--message-hover: hsla(150, 0%, 0%, 0.1);\n}\n\n/* for modern indicators plugin */\n:root {\n  --indicator-border-size: 2px;\n  --indicator-border-style: solid;\n  --indicator-rounding: 0;\n}\n\n.theme-dark {\n  --indicator-unread: 120 70% 60%;\n  --indicator-unread-mention: var(--red-400-hsl);\n  --indicator-selected: 0 0% 90%;\n  --indicator-connected: 0 0% 90%;\n}";
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
      
      # plugins = {
      #   alwaysAnimate.enable = true;
      #   alwaysTrust = {
      #     enable = true;
      #     domain = true;
      #     file = true;
      #   };
      #   anonymiseFileNames = {
      #     enable = true;
      #     method = "consistent";
      #     randomisedLength = 7;
      #     consistent = "file";
      #     anonymiseByDefault = true;
      #   };
      #   betterGifAltText.enable = true;
      #   betterRoleDot = {
      #     enable = true;
      #     bothStyles = false;
      #     copyRoleColorInProfilePopout = false;
      #   };
      #   blurNSFW = {
      #     enable = true;
      #     blurAmount = 10;
      #   };
      #   callTimer = {
      #     enable = true;
      #     format = "human";
      #   };
      #   chatInputButtonAPI.enable = true;
      #   clearURLs.enable = true;
      #   commandsAPI.enable = true;
      #   crashHandler = {
      #     enable = true;
      #     attemptToPreventCrashes = true;
      #     attemptToNavigateToHome = false;
      #   };
      #   decor.enable = true;
      #   disableCallIdle.enable = true;
      #   emoteCloner.enable = true;
      #   experiments = {
      #     enable = true;
      #     toolbarDevMenu = false;
      #   };
      #   fakeProfileThemes = {
      #     enable = true;
      #     nitroFirst = false;
      #   };
      #   favoriteEmojiFirst.enable = true;
      #   favoriteGifSearch = {
      #     enable = true;
      #     searchOption = "hostandpath";
      #   };
      #   fixSpotifyEmbeds = {
      #     enable = true;
      #     volume = 10.0;
      #   };
      #   fixYoutubeEmbeds.enable = true;
      #   forceOwnerCrown.enable = true;
      #   gifPaste.enable = true;
      #   imageZoom = {
      #     enable = true;
      #     saveZoomValues = true;
      #     invertScroll = true;
      #     zoom = 1.555555570272753;
      #     size = 100.0;
      #     zoomSpeed = 0.5;
      #     nearestNeighbour = false;
      #     square = false;
      #   };
      #   memberCount = {
      #     enable = true;
      #     memberList = true;
      #     toolTip = true;
      #   };
      #   memberListDecoratorsAPI.enable = true;
      #   messageAccessoriesAPI.enable = true;
      #   messageClickActions = {
      #     enable = true;
      #     requireModifier = false;
      #     enableDoubleClickToReply = true;
      #     enableDoubleClickToEdit = true;
      #   };
      #   messageDecorationsAPI.enable = true;
      #   messageEventsAPI.enable = true;
      #   messageLinkEmbeds = {
      #     enable = true;
      #     automodEmbeds = "never";
      #     listMode = "blacklist";
      #     idList = "";
      #   };
      #   messageLogger = {
      #     enable = true;
      #     deleteStyle = "text";
      #     ignoreBots = true;
      #     ignoreSelf = true;
      #     ignoreUsers = "";
      #     ignoreChannels = "";
      #     ignoreGuilds = "";
      #     logEdits = true;
      #     logDeletes = true;
      #     collapseDeleted = false;
      #     inlineEdits = true;
      #   };
      #   messagePopoverAPI.enable = true;
      #   messageUpdaterAPI.enable = true;
      #   moreUserTags = {
      #     enable = true;
      #     tagSettings = {
      #       webhook = {
      #         text = "Webhook";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #       owner = {
      #         text = "Owner";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #       administrator = {
      #         text = "Admin";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #       moderatorStaff = {
      #         text = "Staff";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #       moderator = {
      #         text = "Mod";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #       voiceModerator = {
      #         text = "VC Mod";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #       chatModerator = {
      #         text = "Chat Mod";
      #         showInChat = true;
      #         showInNotChat = true;
      #       };
      #     };
      #   };
      #   noBlockedMessages = {
      #     enable = true;
      #     ignoreBlockedMessages = false;
      #   };
      #   noF1.enable = true;
      #   noReplyMention = {
      #     enable = true;
      #     userList = "1234567890123445,1234567890123445";
      #     shouldPingListed = true;
      #     inverseShiftReply = false;
      #   };
      #   noSystemBadge.enable = true;
      #   noTrack = {
      #     enable = true;
      #     disableAnalytics = true;
      #   };
      #   noUnblockToJump.enable = true;
      #   normalizeMessageLinks.enable = true;
      #   onePingPerDM = {
      #     enable = true;
      #     channelToAffect = "both_dms";
      #     allowMentions = false;
      #     allowEveryone = false;
      #   };
      #   openInApp = {
      #     enable = true;
      #     spotify = false;
      #     steam = true;
      #     epic = true;
      #     tidal = true;
      #     itunes = true;
      #   };
      #   permissionsViewer = {
      #     enable = true;
      #     permissionsSortOrder = "highestRole";
      #     defaultPermissionsDropdownState = false;
      #   };
      #   pictureInPicture.enable = true;
      #   pinDMs = {
      #     enable = true;
      #     pinOrder = "mostRecent";
      #     dmSectioncollapsed = false;
      #   };
      #   platformIndicators = {
      #     enable = true;
      #     lists = false;
      #     badges = true;
      #     messages = false;
      #     colorMobileIndicator = true;
      #   };
      #   quickMention.enable = true;
      #   relationshipNotifier = {
      #     enable = true;
      #     notices = true;
      #     offlineRemovals = true;
      #     friends = true;
      #     friendRequestCancels = true;
      #     servers = true;
      #     groups = true;
      #   };
      #   reverseImageSearch.enable = true;
      #   serverInfo.enable = true;
      #   serverListAPI.enable = true;
      #   settings = {
      #     enable = true;
      #     settingsLocation = "aboveActivity";
      #   };
      #   shikiCodeblocks = {
      #     enable = true;
      #     theme = "https://raw.githubusercontent.com/millsp/material-candy/master/material-candy.json";
      #     tryHljs = "SECONDARY";
      #     useDevIcon = "GREYSCALE";
      #     bgOpacity = 100.0;
      #   };
      #   silentTyping = {
      #     enable = true;
      #     showIcon = false;
      #     isEnabled = true;
      #     contextMenu = true;
      #   };
      #   spotifyControls = {
      #     enable = true;
      #     hoverControls = true;
      #     useSpotifyUris = true;
      #   };
      #   spotifyCrack = {
      #     enable = true;
      #     noSpotifyAutoPause = true;
      #     keepSpotifyActivityOnIdle = false;
      #   };
      #   summaries = {
      #     enable = true;
      #     summaryExpiryThresholdDays = 3;
      #   };
      #   supportHelper.enable = true;
      #   translate = {
      #     enable = true;
      #     autoTranslate = false;
      #     showChatBarButton = true;
      #   };
      #   typingIndicator = {
      #     enable = true;
      #     includeCurrentChannel = true;
      #     includeMutedChannels = false;
      #     includeBlockedUsers = false;
      #     indicatorMode = "animatedDots";
      #   };
      #   typingTweaks = {
      #     enable = true;
      #     showAvatars = true;
      #     showRoleColors = true;
      #     alternativeFormatting = true;
      #   };
      #   USRBG = {
      #     enable = true;
      #     voiceBackground = true;
      #     nitroFirst = true;
      #   };
      #   unindent.enable = true;
      #   userSettingsAPI.enable = true;
      #   userVoiceShow = {
      #     enable = true;
      #     showInUserProfileModal = true;
      #     showVoiceChannelSectionHeader = true;
      #     showInMemberList = true;
      #     showInMessages = true;
      #   };
      #   validReply.enable = true;
      #   viewIcons = {
      #     enable = true;
      #     format = "webp";
      #     imgSize = 1024;
      #   };
      #   volumeBooster = {
      #     enable = true;
      #     multiplier = 5;
      #   };
      #   webKeybinds.enable = true;
      #   webScreenShareFixes.enable = true;
      #   youtubeAdblock.enable = true;
      #   petpet.enable = true;
        
      #   # Disabled
      #   alwaysExpandRoles.enable = false;
      #   appleMusicRichPresence.enable = false;
      #   automodContext.enable = false;
      #   banger.enable = false;
      #   betterFolders.enable = false;
      #   betterGifPicker.enable = false;
      #   betterNotesBox.enable = false;
      #   betterRoleContext.enable = false;
      #   betterSessions.enable = false;
      #   betterSettings.enable = false;
      #   betterUploadButton.enable = false;
      #   biggerStreamPreview.enable = false;
      #   clientTheme.enable = false;
      #   colorSighted.enable = false;
      #   consoleJanitor.enable = false;
      #   consoleShortcuts.enable = false;
      #   copyEmojiMarkdown.enable = false;
      #   copyFileContents.enable = false;
      #   copyUserURLs.enable = false;
      #   ctrlEnterSend.enable = false;
      #   customIdle.enable = false;
      #   customRPC.enable = false;
      #   dearrow.enable = false;
      #   dontRoundMyTimestamps.enable = false;
      #   f8Break.enable = false;
      #   fakeNitro.enable = false;
      #   fixCodeblockGap.enable = false;
      #   fixImagesQuality.enable = false;
      #   friendInvites.enable = false;
      #   friendsSince.enable = false;
      #   fullSearchContext.enable = false;
      #   gameActivityToggle.enable = false;
      #   greetStickerPicker.enable = false;
      #   hideAttachments.enable = false;
      #   ignoreActivities.enable = false;
      #   imageLink.enable = false;
      #   implicitRelationships.enable = false;
      #   invisibleChat.enable = false;
      #   keepCurrentChannel.enable = false;
      #   lastFMRichPresence.enable = false;
      #   loadingQuotes.enable = false;
      #   maskedLinkPaste.enable = false;
      #   mentionAvatars.enable = false;
      #   messageLatency.enable = false;
      #   messageTags.enable = false;
      #   moreCommands.enable = false;
      #   moreKaomoji.enable = false;
      #   moyai.enable = false;
      #   mutualGroupDMs.enable = false;
      #   nsfwGateBypass.enable = false;
      #   newGuildSettings.enable = false;
      #   noDefaultHangStatus.enable = false;
      #   noDevtoolsWarning.enable = false;
      #   noMaskedUrlPaste.enable = false;
      #   noMosaic.enable = false;
      #   noOnboardingDelay.enable = false;
      #   noPendingCount.enable = false;
      #   noProfileThemes.enable = false;
      #   noRPC.enable = false;
      #   noScreensharePreview.enable = false;
      #   noServerEmojis.enable = false;
      #   noTypingAnimation.enable = false;
      #   notificationVolume.enable = false;
      #   overrideForumDefaults.enable = false;
      #   partyMode.enable = false;
      #   pauseInvitesForever.enable = false;
      #   permissionFreeWill.enable = false;
      #   plainFolderIcon.enable = false;
      #   previewMessage.enable = false;
      #   quickReply.enable = false;
      #   reactErrorDecoder.enable = false;
      #   readAllNotificationsButton.enable = false;
      #   replaceGoogleSearch.enable = false;
      #   replyTimestamp.enable = false;
      #   revealAllSpoilers.enable = false;
      #   reviewDB.enable = false;
      #   roleColorEverywhere.enable = false;
      #   secretRingToneEnabler.enable = false;
      #   sendTimestamps.enable = false;
      #   serverListIndicators.enable = false;
      #   showAllMessageButtons.enable = false;
      #   showConnections.enable = false;
      #   showHiddenChannels.enable = false;
      #   showHiddenThings.enable = false;
      #   showMeYourName.enable = false;
      #   showTimeoutDuration.enable = false;
      #   silentMessageToggle.enable = false;
      #   sortFriendRequests.enable = false;
      #   spotifyShareCommands.enable = false;
      #   startupTimings.enable = false;
      #   stickerPaste.enable = false;
      #   streamerModeOnStream.enable = false;
      #   superReactionTweaks.enable = false;
      #   textReplace.enable = false;
      #   themeAttributes.enable = false;
      #   timeBarAllActivities.enable = false;
      #   unlockedAvatarZoom.enable = false;
      #   unsuppressEmbeds.enable = false;
      #   userMessagesPronouns.enable = false;
      #   validUser.enable = false;
      #   vcNarrator.enable = false;
      #   vencordToolbox.enable = false;
      #   viewRaw.enable = false;
      #   voiceChatDoubleClick.enable = false;
      #   voiceDownload.enable = false;
      #   voiceMessages.enable = false;
      #   webContextMenus.enable = false;
      #   webRichPresence.enable = false;
      #   whoReacted.enable = false;
      #   XSOverlay.enable = false;
      #   iLoveSpam.enable = false;
      #   oneko.enable = false;
      # };
    };
  };
}
