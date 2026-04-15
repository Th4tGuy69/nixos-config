{ inputs, ... }:

{
  flake.nixosModules.musnix =
    { ... }:
    {
      imports = [ inputs.musnix.nixosModules.musnix ];

      musnix = {
        enable = true;
        kernel.realtime = true;

        alsaSeq.enable = true;
        ffado.enable = false;
        rtcqs.enable = true;
      };
    };
}
