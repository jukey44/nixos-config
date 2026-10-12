# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{

   nixpkgs.config.allowUnfree = true;


security.sudo = {
    enable = true;
    # Use extraConfig to append rules AFTER the default %wheel rule
    extraConfig = ''
      # Allow user 'kyle' to run the touchpad script without password
      kyle ALL=(root) NOPASSWD: /home/kyle/.local/bin/touchpad-toggle
      kyle ALL=(root) NOPASSWD: /run/current-system/sw/bin/tee
    '';
 };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.dc=1"
    "amd_pstate=active"
];   
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

/*  systemd.user.services.niri = {
  # Prevent niri from auto-starting before the display manager
  wantedBy = [ ];
  # Or if the niri-flake sets it via a module:
  enable = lib.mkForce false;
};*/   
  
  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kyle" = {
    isNormalUser = true;
    description = "kyle";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "input" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    inputs.noctalia.overlays.default # Check if noctalia provides an overlay, otherwise stick to packages
  ];

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kyle";
  services.blueman.enable = true;
  #enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#enable ly

#services.displayManager.ly = {
#  enable = true;
  #session = "niri";
  # Optionally set the default session to your Home Manager user
 /* settings = {
    animation = "cmatrix";       # or "doom", "colormix"
    hide_borders = true;
    clock = "%B, %A %d @ %H:%M:%S";
    bigclock = true;
    hide_key_hints = true;
    # bg = "0x02000000";
    # fg = "0x01FFFFFF";
  };*/
#};



#bluetooth

hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

 settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true; # Automatically enables adapters when plugged in
      };
    };
  };

services.asusd = {
    enable = true;
  };


programs.rog-control-center = {
    enable = true;
  };

  
##### setup steam so it works on niri #####
    hardware.graphics = {
    enable = true;
  };
programs.fish.enable = true;
users.users.kyle.shell = pkgs.fish;   

  # ✅ Enable Steam module (Handles dependencies automatically)
  programs.niri.enable = true;
  programs.steam = {
    enable = true;
    # Optional: Enable remote play and controller support
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
###########################################

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  lm_sensors
  linuxPackages.cpupower
  git
  btop
  ly
  pkgs.stress-ng
  pkgs.python314
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
