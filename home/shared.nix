{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    ./niri.nix              # shared niri config (move to shared.nix later)
    ./terminal.nix
  ];

# niri config setup remove niri.nix
xdg.configFile."niri/config.kdl".source = ./config/niri/config.kdl;
 

# packages
  home.packages = with pkgs; [
    # terminal and files
    wget kitty yazi fastfetch btop htop disktui helix
    # apps
    brave discord vlc wine protonplus
    # gaming overlays 
    mangohud goverlay gamescope
    # launcher and lock screen
    fuzzel swaylock
    # minecraft
    prismlauncher

    # work
    pkgs.onlyoffice-desktopeditors

    # planner/notes
    thunderbird obsidian
     
    
  ];

}
