{ config, pkgs, inputs, ... }:
{
  # Import the modules from the flake inputs
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  home.stateVersion = "26.05";

  # --- Niri Configuration ---
  #programs.niri.config = null;
  #xdg.configFile."niri/config.kdl".source =
  #./home/kyle/.config/niri/config.kdl.backup;
  programs.niri = {
  enable = true;
  package = pkgs.niri;
  settings = {
   /* layout.gaps = 20;
   layout.border.enable = true;
#    layout.shadow = true;
    input.keyboard.xkb.layout = "us";
*/

  hotkey-overlay.skip-at-startup = true;
  prefer-no-csd = true;
   layout = {
      gaps = 20;

      border = {
        enable = true;
        width = 4;
        active.color = "#ffc87f";
        inactive.color = "#505050";
        urgent.color = "#9b0000";
      };
      focus-ring.enable = false;
      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset.x = 0;
        offset.y = 5;
        draw-behind-window = true;
        color = "#00000070";
      };

      struts = {
        top = 36;
        bottom = 36;
        left = 55;
        right = 55;
      };
    };
 # };
#};
    outputs = { 

	"eDP-1" = {
	mode = {
	width = 2560;
	height = 1440;
	refresh = 165.003; 
	};
	scale = 1.5;
	position = { x = 0; y = 0;};
	focus-at-startup = true;
	variable-refresh-rate = true;
	};
    };
   spawn-at-startup = [
        { argv = [ "noctalia" ]; }

	{ argv = ["sh" "-c" "gdbus wait --session org.kde.StatusNotifierWatcher && rog-control-center" ]; }
  ];
  window-rules = [ {
    geometry-corner-radius = {
       top-left = 14.0;
      top-right = 14.0;
      bottom-left = 14.0;
      bottom-right = 14.0; };
    
    clip-to-geometry = true;
  
}
];
    binds = with config.lib.niri.actions; {
    
    	"XF86TouchpadToggle".action = spawn [ "/home/kyle/.local/bin/touchpad-toggle" ];

	"XF86Launch4".action = { spawn = "home/kyle/.local/bin/power-cycle"; };
	"XF86Launch1".action =  { spawn = "rog-control-center"; };
        "Mod+Shift+T".action = spawn [ "/home/kyle/.local/bin/ps5-touchpad-toggle" ];

        # center
        "Mod+C".action = center-column;
        "Mod+Shift+C".action = center-visible-columns;
        
        # toggle float or tiling
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling; 

        # Terminal
        "Mod+Return".action = { spawn = "kitty"; };
        "Mod+E".action = { spawn-sh = "kitty yazi"; };
        "Mod+B".action = { spawn = "brave"; };
	      "Mod+S".action = { spawn = "steam"; };
        # Window Management
        "Mod+Q".action = { close-window = {}; };
	      "Mod+F".action = fullscreen-window;
	      "Mod+Ctrl+F".action = toggle-windowed-fullscreen;
        "Mod+T".action =  toggle-window-floating;

	      "Mod+Minus".action = set-column-width "-10%";
	      "Mod+Equal".action = set-column-width  "+10%";

	      "Mod+I".action = { focus-workspace-up = {}; };
        "Mod+U".action = { focus-workspace-down = {}; };
	      "Mod+Ctrl+I".action = { move-column-to-workspace-up = {}; };
        "Mod+Ctrl+U".action = { move-column-to-workspace-down = {}; };
        
 
        
        "Mod+Shift+Minus".action = set-window-height  "-10%";
	      "Mod+Shift+Equal".action = set-window-height  "+10%";

        # Focus (Vim Style)
        "Mod+H".action = { focus-column-left = {}; };
        "Mod+L".action = { focus-column-right = {}; };
        "Mod+K".action = { focus-window-up = {}; };
        "Mod+J".action = { focus-window-down = {}; };
        
        # Focus (Vim Style)
        "Mod+LEFT".action = { focus-column-left = {}; };
        "Mod+RIGHT".action = { focus-column-right = {}; };
        "Mod+UP".action = { focus-window-up = {}; };
        "Mod+DOWN".action = { focus-window-down = {}; };

         # Move Window
        "Mod+Ctrl+H".action = { move-column-left = {}; };
        "Mod+Ctrl+L".action = { move-column-right = {}; };
        "Mod+Ctrl+K".action = { move-window-up = {}; };
        "Mod+Ctrl+J".action = { move-window-down = {}; };
        
        # Move Window
        "Mod+Ctrl+LEFT".action = { move-column-left = {}; };
        "Mod+Ctrl+RIGHT".action = { move-column-right = {}; };
        "Mod+Ctrl+UP".action = { move-window-up = {}; };
        "Mod+Ctrl+DOWN".action = { move-window-down = {}; };
         # Noctalia v5 Actions (Launcher, Lock, etc.)
        # Note: v5 uses 'noctalia msg' instead of 'noctalia-shell ipc'
        "Mod+Space".action = { spawn = [ "noctalia" "msg" "panel-toggle" "launcher" ]; };
        "Mod+Ctrl+Shift+L".action = { spawn = [ "noctalia" "msg" "session" "lock" ]; };
        
        # Screenshot (Requires grimblast in home.packages)
        "Mod+Ctrl+S".action = { spawn = [ "grimblast" "save" "area" ]; };
       
        # Audio (Requires pactl or wpctl)
        "XF86AudioRaiseVolume".action = { spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" ]; };
        "XF86AudioLowerVolume".action = { spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" ]; };
        "XF86AudioMute".action = { spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; };
      };
};
};

  # ly display manager

# In your home.nix or flake.nix
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

  # --- Noctalia v5 Configuration ---
  programs.noctalia = {
    enable = true;
    # v5 uses TOML. You can generate this file or write it inline.
    settings = builtins.fromTOML (builtins.readFile ./noctalia-config.toml);
  };

  # Install user packages
  home.packages = with pkgs; [
    kitty
    fastfetch
    yazi
    superfile
    glib
    mangohud
    goverlay
    xinput   # Provides xinput
    libnotify     # Provides notify-send
    steam
    fuzzel
    brave
    inputs.xwayland-satellite.packages.x86_64-linux.xwayland-satellite
  ];

  # Let Home Manager manage the session
  home.sessionPath = [ "$HOME/.nix-profile/bin" ];
}
