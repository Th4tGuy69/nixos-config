{ ... }:

{
  flake.nixosModules.steam =
    { ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      hardware = {
        steam-hardware.enable = true; # VR
        xone.enable = true; # XBox
        xpadneo.enable = true;
      };
    };
}
