{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    ./niri.nix              # shared niri config (move to shared.nix later)
    ./terminal.nix
  ];

#niri config setup remove niri.nix
xdg.configFile."niri/config.kdl".source = ./config/niri/config.kdl;
 
}
