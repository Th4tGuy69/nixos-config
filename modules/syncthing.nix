{ ... }:

{
  services.syncthing = {
    enable = true;
    #openDefaultPorts = true;
    settings = {
      devices = {
        "Server".id = "RI62BYO-GNPWFKL-PI5QJRQ-GX56CHA-5SYZF7Q-NAOUIK3-MWH3CTI-UETTZQO";
        "1+8 Pro".id = "WOHYSE2-B6FMWLU-55DZMNF-ACSNXQU-CGCPM2H-CZ4ASOB-PNTECT7-MJ63UAS";
      };
      folders = {
        "MUS 313" = {
          label = "MUS 313";
          path = "/home/thatguy/Documents/GitHub/College/OSU/MUS 313";
          type = "receiveonly";
          devices = [ "Server" "1+8 Pro" ];
        };
      };
      gui.theme = "black";
      options = {
        gui.theme = "black";
      };
    };
  };
}
