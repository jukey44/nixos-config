# Desktop (kyle): system-level config.
# User-level apps and dotfiles move to home/desktop.nix once home-manager is on.

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

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
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # -------------------------------------------------------------- Fonts
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

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
  services.ratbagd.enable = true;

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
    gc      = "sudo nix-collect-garbage --delete-older-than 14d";
  };

  # System essentials
  environment.systemPackages = with pkgs; [
    wget
    helix
    ntfs3g
    libratbag
    inputs.xwayland-satellite.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite
  ]
  # User apps: they move to home/desktop.nix once home-manager is on the desktop.
  ++ (with pkgs; [
    # terminal and files
    kitty yazi superfile fastfetch btop htop disktui
    # apps
    brave discord vlc gimp krita kdePackages.kdenlive easyeffects wine
    # gaming overlays
    mangohud goverlay
    # launcher, lock screen, mouse config, cursor theme
    fuzzel swaylock  bibata-cursors
  ]);

  # Do not change this after install, even when upgrading NixOS.
  system.stateVersion = "26.05";
}
