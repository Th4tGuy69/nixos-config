{ ... }:

{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "Server".id = "RI62BYO-GNPWFKL-PI5QJRQ-GX56CHA-5SYZF7Q-NAOUIK3-MWH3CTI-UETTZQO";
        "1+8 Pro".id = "45YINXC-PFTLIOQ-EN6O2LO-OKHJFMX-O6A576E-YQOFOFX-XG4F5EW-DIVFGAS";
      };
      folders = {
        "Obsidian" = {
          label = "Vault";
          path = "/home/thatguy/Documents/GitHub/Obsidian";
          type = "sendreceive";
          devices = [ "Server" "1+8 Pro" ];
        };
      };
      gui.theme = "black";
      options = {
        gui.theme = "black";
        urAccepted = 1;
      };
    };
  };
}
