{ config, ... }:

let
  deviceID = "NixOS";
  nextdnsID = ${config.sops.placeholder.nextdnsID};
in

{
  services.resolved = {
    enable = true;
    extraConfig = ''
      [Resolve]
      DNS=45.90.28.0#${toString deviceID}-${toString nextdnsID}.dns.nextdns.io
      DNS=2a07:a8c0::#${toString deviceID}-${toString nextdnsID}.dns.nextdns.io
      DNS=45.90.30.0#${toString deviceID}-${toString nextdnsID}.dns.nextdns.io
      DNS=2a07:a8c1::#${toString deviceID}-${toString nextdnsID}.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };
}
