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
  # local ai agent
programs.opencode = {
  enable = true;
  settings = {
    provider.ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options = {
        baseURL = "http://localhost:11434/v1";
        apiKey = "ollama";
      };
      models ={
        "gpt-oss-32k" = {
        name = "gpt-oss 20b 32k";
        tool_call = true;
       };
        "gemma4:12b" = {
          name = "Gemma 4 12B";
          tool_call = true;
        };
      
      };
    };
    model = "ollama/gpt-oss-32k";
  };
};

    # Optional: actually applies the cursor theme (installing the package alone doesn't)
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    };
  
}
