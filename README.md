NixOS Configuration

Personal NixOS setup for three machines, managed from one Git repository with Nix flakes and Home-Manager: my desktop PC, my laptop, and a Minecraft server running in a NixOS VM on Proxmox. Any of them can be rebuilt from this repo.

What this demonstrates
Reproducible systems. Each machine is defined in code, and inputs are pinned in flake.lock, so a rebuild gives the same result.
Multi-host management. One flake, three hosts, with shared pieces kept in one place and host-specific settings kept separate.
User environment as code. Home-Manager (built into the flake as a NixOS module) handles per-user settings for the desktop and laptop: terminal, file manager, and the niri desktop.
Safe changes. nixos-rebuild test before switch, and a one-command rollback if an update breaks something.
A real service. The mcserver host runs a Minecraft server (Paper, with Geyser/Floodgate so Bedrock players can join) that my family uses over Tailscale.
Hosts
Host	What it is	Home-Manager config
kyle	Main desktop PC	home/desktop.nix
laptop	Laptop	home/laptop.nix
mcserver	Minecraft server, NixOS VM on Proxmox	none (system only)
Repository layout
.
├── flake.nix              # Entry point: defines the three nixosConfigurations
├── flake.lock             # Pinned inputs
├── hosts/
│   ├── kyle/              # configuration.nix, hardware-configuration.nix, noctalia.nix
│   ├── laptop/            # configuration.nix, hardware-configuration.nix
│   └── mcserver/          # configuration.nix, hardware-configuration.nix, minecraft.nix
└── home/                  # Home-Manager configs and app settings (kitty, niri, yazi)
Usage

Replace <host> with kyle, laptop, or mcserver.

bash
git clone https://github.com/jukey44/nixos-config.git
cd nixos-config

# Build and activate temporarily (reverts on reboot)
sudo nixos-rebuild test --flake .#<host>

# Make it permanent
sudo nixos-rebuild switch --flake .#<host>

# Roll back to the previous generation
sudo nixos-rebuild switch --rollback

Home-Manager is part of the system build for kyle and laptop, so nixos-rebuild switch applies user settings too. There is no separate home-manager switch step.

For mcserver, I push changes from my desktop, run git pull on the VM, and rebuild there.

Troubleshooting
Unknown host: the name after # must match an entry in flake.nix.
Build fails: run nix flake check and read the first error, not the last.
Service won't start: journalctl -b -u <service>.
Tools

NixOS (unstable), Nix flakes, Home-Manager, niri, Noctalia, kitty, yazi, Proxmox, Tailscale.
