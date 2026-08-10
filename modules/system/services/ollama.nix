{ ... }:

{
  flake.nixosModules.ollama =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        home = "/data/Ollama";
        loadModels = [ "qwen2.5-coder:14b" ];
        rocmOverrideGfx = "11.0.0";
      };
    };
}
