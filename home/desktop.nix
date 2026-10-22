{ config, pkgs, inputs, ... }:
{
  imports = [ ./terminal.nix ./shared.nix];

  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  home.stateVersion = "26.05";     # matches your system.stateVersion
 
  xdg.configFile."niri/host.kdl".source = ./config/niri/host-desktop.kdl;
  
  home.packages = with pkgs; [

    # apps
     vlc gimp krita kdePackages.kdenlive easyeffects
  ];


  # programs.claude-code = {
    # enable = true;
    # apiKey = "";
    
  # };

  # Optional: actually applies the cursor theme (installing the package alone doesn't)
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    };
  home.sessionVariables = {
    ANTHROPIC_DEFAULT_SONNET_MODEL = "gpt-oss:20b";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "gpt-oss:20b";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "gpt-oss:20b";
    CLAUDE_CODE_SUBAGENT_MODEL = "gpt-oss:20b";
  };

}
