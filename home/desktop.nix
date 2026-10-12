{ config, pkgs, inputs, ... }:
{
  imports = [ ./terminal.nix ./shared.nix];

  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  home.stateVersion = "26.05";     # matches your system.stateVersion

  home.packages = with pkgs; [

    # apps
     vlc gimp krita kdePackages.kdenlive easyeffects
  ];

  # Optional: actually applies the cursor theme (installing the package alone doesn't)
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
  };
}
