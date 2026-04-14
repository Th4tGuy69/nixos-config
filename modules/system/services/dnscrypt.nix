{ ... }:

{
  flake.nixosModules.dnscrypt =
    { ... }:
    {
      services.dnscrypt-proxy = {
        enable = false;
        settings = {
          listen_addresses = [
            "127.0.0.1:53"
            "[::1]:53"
          ];

          bootstrap_resolvers = [
            "9.9.9.9:53"
            "149.112.112.112:53"
          ];

          ipv6_servers = true; # IPv6 support
          http3 = true; # HTTPS w/ QUIC support

          # Allow DNS logs and filters
          require_nolog = false;
          require_nofilter = false;

          # Multiple server names - dnscrypt-proxy will try them in order
          # Mix your custom server with public fallbacks
          server_names = [
            "DoH"
            "quad9"
          ];

          static = {
            # "QUIC".stamp = "sdns://BAEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3MgAUZG5zLnRoYXQtZ3V5LmRldjo4NTM"; # Not supported
            "DoH".stamp = "sdns://AgEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3MgAQZG5zLnRoYXQtZ3V5LmRldgovZG5zLXF1ZXJ5";
            # "DoT".stamp = "sdns://AwEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3MgAUZG5zLnRoYXQtZ3V5LmRldjo4NTM"; # Malformed or not supported
            # "DNS".stamp = "sdns://AAEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3Mg";
          };
        };
      };
    };
}
