# hosts/mcserver/minecraft.nix
{ pkgs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.papermc;
    declarative = true;
    openFirewall = false; # ports are opened on tailscale0 below

    # Keep this below the VM's RAM (give the VM about 6 GB)
    jvmOpts = "-Xms2G -Xmx4G";

    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      difficulty = "normal";
      max-players = 8;
      motd = "Family server";
      view-distance = 10;
      white-list = true;
    enforce-whitelist = true;

    # testing push pull
    };
    
    whitelist = {
    kyle = "e05fdcb5-519b-4f52-9d94-5ed535ac6432";
    ".KeyThought74351" = "00000000-0000-0000-0009-01f3d2cb20b8";
    # sibling = "their-uuid-here";
    };
  };
      # online-mode stays at its default (true). Floodgate lets Bedrock
      # players join without a Java account, so there is no need to turn
      # authentication off.
    
  

  # Reachable only over Tailscale (no router port forwarding).
  # Java = TCP 25565, Bedrock via Geyser = UDP 19132.
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 25565 22 ];
    allowedUDPPorts = [ 19132 ];
  };

  # Geyser and Floodgate run as plugins inside Paper, not as a separate
  # service. After the first rebuild:
  #   1. Put Geyser-Spigot.jar and floodgate-spigot.jar in
  #      /var/lib/minecraft/plugins/
  #   2. sudo chown minecraft:minecraft /var/lib/minecraft/plugins/*.jar
  #   3. sudo systemctl restart minecraft-server
  #   4. Set auth-type: floodgate in
  #      /var/lib/minecraft/plugins/Geyser-Spigot/config.yml, then restart.
}
