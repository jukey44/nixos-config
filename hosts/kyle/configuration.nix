# Desktop (kyle): system-level config.
# User-level apps and dotfiles move to home/desktop.nix once home-manager is on.

{ config, pkgs, inputs, lib,  ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;   
  
  # ---------------------------------------------------------------- Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # ---------------------------------------------------------- Networking
  networking.hostName = "kyle";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;
  hardware.enableRedistributableFirmware = true;

  # ------------------------------------------------------------- Storage
  fileSystems."/mnt/steamstorage" = {
    device = "/dev/disk/by-label/extrastorage";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/Wstorage" = {
    device = "/dev/disk/by-label/NewVolume";
    fsType = "ntfs-3g";
    options = [ "nofail" "rw" "uid=1000" ];
  };

  # -------------------------------------------------- Locale and keyboard
  time.timeZone = "America/Detroit";

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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ---------------------------------------------------------------- Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # --------------------------------------------------------------- User
  users.users."kyle" = {
    isNormalUser = true;
    description = "kyle";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ];
  };

  # -------------------------------------------------------------- Fonts
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

/*  # autostart opendeck
environment.etc."xdg/autostart/opendeck.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Name=OpenDeck
  Exec=sh -c "sleep 10 && flatpak run me.amankhanna.opendeck --hide
  X-GNOME-Autostart-enabled=true
'';   
*/
  
  # ----------------------------------------------------------- Programs
  programs.fish.enable = true;
  programs.git.enable = true;       # move to home-manager later if you want
  programs.nano.enable = false;
  programs.niri.enable = true;
  programs.nix-ld.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  # ----------------------------------------------------------- Services
  services.flatpak.enable = true;

  # Gpu
  hardware.graphics = {
    enable = true;
  };
  
  # AI services
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    # Use the host option to set the IP and variables
    host = "0.0.0.0"; 
  };

  # This is the correct way to inject extra environment variables 
  # into the systemd service in this specific NixOS module:
  systemd.services.ollama.environment = {
    OLLAMA_CONTEXT_LENGTH = "32768";
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    OLLAMA_ORIGINS = "*";
  }; 
  services.tailscale.enable  = true;
  
  services.open-webui = {
    enable = true;
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://100.69.237.38:11434";
      # This forces the web interface to allow your phone's connection
      WEBUI_ORIGINS = "*";
    };
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8080 ];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb-with-all-plugins;
    server.port = 6742;
    startupProfile = "my-profile.json";
  };

  # Stop the GP13 PCI device from waking the machine
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:08.1", ATTR{power/wakeup}="disabled"
  '';

  # Ulanzi D200 access. This stays a "70-" rules package on purpose: the
  # uaccess tag has to be applied before systemd's 73-seat-late rules, which
  # extraRules (99-local.rules) would be too late for.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "70-ulanzi-d200.rules";
      destination = "/etc/udev/rules.d/70-ulanzi-d200.rules";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2207", ATTRS{idProduct}=="0019", MODE="0660", TAG+="uaccess"
      '';
    })
  ];

  security.pam.services.swaylock = { };  # needed for swaylock to unlock

  # -------------------------------------------------------- Environment
  environment.variables.EDITOR = "hx";

  environment.shellAliases = {
    rebuild = "git -C ~/nixos-config add . && sudo nixos-rebuild switch --flake ~/nixos-config#kyle";
    update  = "nix flake update --flake ~/nixos-config && rebuild";
    gens    = "nixos-rebuild list-generations";
    gc      = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3 && nix-collect-garbage --delete-older-than 14d";
    nc = "cd nixos-config";
  };

  # System essentials
  environment.systemPackages = with pkgs; [
    wget
    ntfs3g
    inputs.xwayland-satellite.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite
  ];

  # Do not change this after install, even when upgrading NixOS.
  system.stateVersion = "26.05";
}
