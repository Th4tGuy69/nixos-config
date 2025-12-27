{ inputs, system, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;

    profiles."Test".extensions.packages = with inputs.firefox-addons.packages.${system}; [
      ublock-origin
    ];
  };
}
