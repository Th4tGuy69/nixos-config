{
  pkgs,
  inputs,
  system,
  ...
}:

{
  home.packages = with pkgs; [
    (inputs.wayvid.packages.${system}.default.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ openssl ];
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkg-config ];

      postInstall = ''
        # Install systemd service
        install -Dm644 systemd/wayvid.service \
          $out/lib/systemd/user/wayvid.service

        # Install example config if it exists
        if [ -f configs/config.example.yaml ]; then
          install -Dm644 configs/config.example.yaml \
            $out/share/wayvid/config.example.yaml
        fi

        # Install documentation files if they exist
        if [ -f README.md ]; then
          install -Dm644 README.md $out/share/doc/wayvid/README.md
        fi
      '';
    }))
  ];
}
