{ pkgs, ... }:

let
  seanime = import ../packages/seanime { pkgs = pkgs; };
in
  
{
  home.packages = [ seanime ];
}
