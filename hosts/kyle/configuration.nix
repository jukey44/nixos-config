# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Disable GP13
  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:08.1", ATTR{power/wakeup}="disabled"
'';   
  boot.supportedFilesystems = [ "ntfs" ];
  #mnt files
  fileSystems."/mnt/steamstorage" = {
  device = "/dev/disk/by-label/extrastorage";
  fsType = "ext4";
  options = [ "nofail"];
};   
   fileSystems."/mnt/Wstorage" = {
  device = "/dev/disk/by-label/NewVolume";
  fsType = "ntfs-3g";
  options = [ "nofail" "rw" "uid=1000" ];
}; 
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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

#flake setup
nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #fonts

# autostart opendeck
environment.etc."xdg/autostart/opendeck.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Name=OpenDeck
  Exec=flatpak run me.amankhanna.opendeck --hide
  X-GNOME-Autostart-enabled=true
'';   
  
  # configuration.nix
fonts.fonts = [ ];  # remove unused fonts
# Or disable specific problematic configs:
fonts.fontconfig.enable = true;  # keep, but trim /etc/fonts/conf.d if needed

# Obs plugins
 programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

#programs
  programs.steam = {
  enable = true;
  extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
  
};

  programs.git.enable = true;
  programs.opendeck.enable = true;
  programs.nano.enable =false;
  programs.niri.enable = true;
  programs.nix-ld.enable = true;    
  # Services
  services.udev.packages = [
  (pkgs.writeTextFile {
    name = "70-ulanzi-d200.rules";
    destination = "/etc/udev/rules.d/70-ulanzi-d200.rules";
    text = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2207", ATTRS{idProduct}=="0019", MODE="0660", TAG+="uaccess"
    '';
  })
];
  services.flatpak.enable = true;   
  services.hardware.openrgb = {
  enable = true;
  motherboard = "amd";  # or "intel" — loads i2c-piix4 or i2c-i801
  package = pkgs.openrgb-with-all-plugins;  # all plugins, not just core
  server.port = 6742;
  startupProfile = "my-profile.json";  # optional: load a profile at boot
};   

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # configuration.nix
environment.variables.EDITOR = "hx";
  
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fish
    kitty
    fuzzel
    discord
    helix
    steam
    niri
    brave
    inputs.xwayland-satellite.packages.x86_64-linux.xwayland-satellite
    mangohud
    goverlay
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.protonplus
    swaylock
    yazi
    vlc
    disktui
    fastfetch
    easyeffects
    openrgb
    btop
    htop
    kdePackages.kdenlive
    ntfs3g
    wine
    gimp
    krita
    pkgs.piper
    pkgs.libratbag
    superfile
    pkgs.bibata-cursors
    
  ];
 /* nixpkgs.config.permittedInsecurePackages = [
                "nodejs-20.20.2"
                "nodejs-slim-20.20.2"
              ];*/
security.pam.services.swaylock = {};
services.ratbagd.enable = true;

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
