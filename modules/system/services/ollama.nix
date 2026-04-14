{ ... }:

{
  flake.nixosModules.ollama =
    { ... }:
    {
      services.ollama = {
        enable = true;
        home = "/data/Ollama";
        loadModels = [ "qwen2.5-coder:14b" ];
        rocmOverrideGfx = "11.0.0";
      };
    };
}
