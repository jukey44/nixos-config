# NixOS Configuration Repository

A personal, production‑ready NixOS configuration that demonstrates declarative system provisioning with Nix flakes, Home‑Manager user configuration, and multi‑host management.

The repo is structured to keep everything reproducible while allowing host‑specific overrides and user‑space customisations.

---

## Overview

- **`home/`** – Home‑Manager configuration for my user, including per‑desktop layout and application settings.
- **`hosts/`** – Host‑specific system configuration files (`configuration.nix`, `hardware-configuration.nix`, optional per‑host modules).
- **`modules/`** – Reusable NixOS or Home‑Manager modules (currently empty, but ready for community or personal reuse).
- **`flake.nix`** – The single entry point for the Nix flake, exposing the host and home configurations.

This repository is ready to be cloned, built, and deployed to any NixOS VM or laptop, or used locally for experimentation.

---

## Repository Structure

```
.
├── flake.nix                # Nix flake entry point – exposes nixosConfigurations & homeConfigurations
├── hosts
│   ├── kyle
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── noctalia.nix
│   ├── laptop
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── mcserver
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── minecraft.nix
├── home
│   ├── config
│   │   ├── kitty
│   │   │   └── kitty.conf
│   │   ├── niri
│   │   │   ├── config.kdl
│   │   │   ├── host-desktop.kdl
│   │   │   ├── host-laptop.kdl
│   │   ├── nixpkgs
│   │   │   └── config.nix
│   │   ├── niri.nix
│   │   ├── noctalia-config.toml
│   │   ├── result
│   │   ├── shared.nix
│   │   ├── terminal.nix
│   │   └── yazi
│   │       └── yazi.toml
│   └── [other Home‑Manager files – e.g., host‑specific overlays]
├── modules
│   └── (reusable modules – currently empty)
└── README.md
```

> *Files in `home/` are bundled with the Home‑Manager configuration and are optional for a system‑only deployment.*

---

## Getting Started

Clone the repo and bootstrap a NixOS machine:

```bash
# Clone the repository
git clone https://github.com/<your-github-username>/nixos-config.git
cd nixos-config

# Build and test a host configuration (replace `laptop` with your host name)
sudo nixos-rebuild test --flake .#laptop

# If the test succeeds, apply the changes
sudo nixos-rebuild switch --flake .#laptop
```

**NOTE:** If you’re building on a fresh VM, you can install Nix first:

```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

Then run the commands above.

---

## Home‑Manager Integration

Each host can include a Home‑Manager configuration via its `home.nix` (or `home/<user>.nix`).  The `home/` directory in this repo contains all user‑level settings for desktop components such as Kitty, Niri, Yazi, and your customized terminal.

Deploy Home‑Manager after a system rebuild:

```bash
# Switch the system configuration first
sudo nixos-rebuild switch --flake .#laptop

# Apply Home‑Manager for the current user
home-manager switch --flake .#laptop
```

---

## Key Features

| Feature | What it shows | Relevance to support roles |
|---------|---------------|---------------------------|
| Declarative config | System & home settings defined in `.nix` files | Removes ad‑hoc scripting; easier to audit |
| Multi‑host support | Separate `hosts/*` directories | Demonstrates ability to manage several machines |
| Home‑Manager | User‑space configuration | Typical help‑desk task for desktop personalization |
| Reproducible builds | Pinning through flake inputs | Critical for debugging or backing up a system |
| Rollback | `nixos-rebuild switch --rollback` | Quickly revert after problematic updates |

---

## Common Commands

```bash
# Test configuration (no changes applied)
nixos-rebuild test --flake .#<host>

# Switch to the new configuration
sudo nixos-rebuild switch --flake .#<host>

# Rollback last switch
sudo nixos-rebuild switch --rollback

# Check the evaluated options for a host
nixos-option --flake .#<host> <option.path>

# Apply Home‑Manager for a host
home-manager switch --flake .#<host>
```

---

## Troubleshooting

- **Unknown host in flake** – Ensure the host name in the command matches the entry in `flake.nix`.
- **Service fails to start** – Inspect logs: `journalctl -b -u <service>`.
- **Build failures** – Run `nix flake check` and verify all inputs are reachable.
- **Permission issues** – Home‑Manager commands must be run as the user owning the home directory.

---

## Resources

- NixOS manual (stable) – https://nixos.org/manual/nixos/stable
- Nix Flakes guide – https://nixos.org/manual/nix/stable/#chap-flakes
- Home‑Manager – https://ryantm.github.io/home-manager/

