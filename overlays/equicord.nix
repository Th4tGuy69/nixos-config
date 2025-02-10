self: super: {
  discord = super.discord.override ({ withOpenASAR ? false, withVencord ? false, ... }@args: args) // {
    override = { withOpenASAR ? false, withVencord ? false, withEquicord ? false, ... }@args:
      let 
        pkg = super.discord.override (builtins.removeAttrs args ["withEquicord"]);
      in
      if withEquicord then
        pkg.overrideAttrs (oldAttrs: {
          pname = oldAttrs.pname + "-equicord";
          withVencord = true;
          postInstall = ''
            rm -rf $out/opt/discord/resources/app.asar
            mkdir -p $out/opt/discord/resources/app.asar
            
            # Setup base Discord
            echo '{"name":"discord","main":"index.js"}' > $out/opt/discord/resources/app.asar/package.json
            echo 'require("./desktop/patcher.js")' > $out/opt/discord/resources/app.asar/index.js
            
            # Copy Equicord files
            cp -r ${super.equicord}/desktop $out/opt/discord/resources/app.asar/
            cp ${super.equicord}/vencordDesktopRenderer.* $out/opt/discord/resources/app.asar/
            cp ${super.equicord}/equibop.asar $out/opt/discord/resources/
          '';
        })
      else pkg;
  };
}
