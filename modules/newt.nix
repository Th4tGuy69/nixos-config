{ config, ... }:

{
  sops.secrets.newt = {};
  sops.templates."newt-credentials.env".content = ''
      NEWT_ID=${config.sops.placeholder.newt-id}
      NEWT_SECRET=${config.sops.placeholder.newt-secret}
      PANGOLIN_ENDPOINT=https://pangolin.that-guy.dev
    '';
  
  services.newt = {
    enable = true;
    environmentFile = "${config.sops.templates."newt-credentials.env".path}";
  }; 
}
