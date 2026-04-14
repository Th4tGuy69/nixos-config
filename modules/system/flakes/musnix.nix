{ ... }:

{
  flake.nixosModules.musnix =
    { pkgs, ... }:
    {
      musnix = {
        enable = true;

        alsaSeq.enable = true;
        ffado.enable = false;
        rtcqs.enable = true;

        kernel = {
          realtime = true;
          # packages = pkgs.linuxPackages_latest_rt;
          # https://github.com/musnix/musnix/issues/206#issuecomment-3632117934
          packages =
            with pkgs;
            linuxPackagesFor (
              linux_6_12.override {
                structuredExtraConfig = with lib.kernel; {
                  EXPERT = yes;
                  PREEMPT_RT = yes;
                  RT_GROUP_SCHED = no;
                  PREEMPT_VOLUNTARY = lib.mkForce no;
                };
                ignoreConfigErrors = true;
              }
            );
        };
      };
    };
}
