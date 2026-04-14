{ self, ... }:

{
  flake.homeModules.pipewire =
    { ... }:
    {
      imports = [
        self.homeModules.hrtf-EQ
      ];
    };
}
