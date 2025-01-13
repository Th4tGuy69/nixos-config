{ pkgs, ... }:

let
  oxalica = pkgs // {
    overlays = [
      (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ]; 
  };

  rustPlatform = oxalica.makeRustPlatform {
    cargo = oxalica.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = oxalica.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in

rustPlatform.buildRustPackage {
  pname = "hyprwatch";
  version = "1.0.0";  # Adjust the version if necessary

  # Fetch the repository from GitHub
  src = pkgs.fetchFromGitHub {
    owner = "VirtCode";
    repo = "hyprwatch";
    rev = "main";  # You can specify a specific commit hash or branch here
    sha256 = "sha256-mFhcVl3gAtafBsN24j3sKlXv2j0yINkXEIS+U+/mQ2c=";  # Replace with the actual sha256 once fetched
  };

  cargoHash = "sha256-DkJaf7t+LsQE5eHjNe5G3pO5JCjohtWtls6EfJ9VAio=";

  # Optionally, if you need to run `cargo install` to build it,
  # it can be done in the build phase, but `buildRustPackage` is
  # usually sufficient for most crates
  meta = with pkgs.lib; {
    description = "hyprwatch is a CLI abstraction over Hyprland's event socket which makes it easier to use and adds some extra data.";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

