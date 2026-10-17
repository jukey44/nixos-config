# /hosts/mcserver/minecraft.nix
{ config, pkgs, ... }:

let
  papermc    = pkgs.papermc;            # Paper‑MC jar
  geyser     = pkgs.geysermc;           # Geyser‑MC
  javaRuntime = pkgs.jre-openjdk;       # Java runtime for Geyser
in
{
  ##########################################################
  # 1️⃣  Minecraft (Paper‑MC)
  ##########################################################
  services.minecraft.servers.myserver = {
    enable   = true;
    package  = papermc;

    # `server.properties` – edit as needed
    serverProperties = {
      online-mode = false;          # set true if you want Mojang auth
      max-players = 20;
      # …other properties you want…
    };

    # Java runtime & options
    java = {
      enable = true;
      version = 17;                # or 21 if you prefer
    };
    environment.JVM_OPTS = "-Xms4G -Xmx8G";

    # Port that the firewall will expose
    port = 25565;
  };

  ##########################################################
  # 2️⃣  Geyser‑MC (Bedrock → Java)
  ##########################################################
  systemd.services.geyser = {
    description = "GeyserMC Bedrock proxy";
    wantedBy = [ "multi-user.target" ];

    # Make sure Geyser starts *after* the Minecraft server
    after = [ "network-online.target" "minecraft.service" ];
    requires = [ "minecraft.service" ];

    serviceConfig = {
      User = "minecraft";
      Group = "minecraft";
      WorkingDirectory = "/var/lib/minecraft";

      ExecStart = "${javaRuntime}/bin/java -jar ${geyser}/share/geysermc/geyser.jar \
        --server 127.0.0.1:25565 \
        --bedrock-port 19132";

      Restart = "on-failure";
      Environment = "GEYSER_LOG_LEVEL=info";
    };
  };

  # Tell the firewall about Geyser’s Bedrock port
  networking.firewall.allowedTCPPorts =
    config.networking.firewall.allowedTCPPorts ++ [ 19132 ];

  # Ensure the Minecraft world directory is owned by the minecraft user
  systemd.services.minecraft.serviceConfig = {
    User = "minecraft";
    Group = "minecraft";
    WorkingDirectory = "/var/lib/minecraft";
  };
}
