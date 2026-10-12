{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    ./terminal.nix
    ./shared.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  home.stateVersion = "26.05";


  # Laptop-only niri bits (display, ROG, touchpad), pulled in by the shared config
  xdg.configFile."niri/host.kdl".source = ./config/niri/host-laptop.kdl;

  # ly display manager
  home.file.".local/share/xsessions/niri.desktop".source = pkgs.writeTextFile {
    name = "niri.desktop";
    text = ''
      [Desktop Entry]
      Name=Niri
      Comment=Niri Wayland Session
      Exec=${pkgs.niri}/bin/niri
      Type=Application
    '';
  };

  # --- Noctalia v5 ---
  programs.noctalia = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./noctalia-config.toml);
  };

  home.packages = with pkgs; [
    glib
    mangohud
    goverlay
    xinput
    libnotify
    inputs.xwayland-satellite.packages.x86_64-linux.xwayland-satellite
  ];

  home.sessionPath = [ "$HOME/.nix-profile/bin" ];
}
