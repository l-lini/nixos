{ port }:
{ username, pkgs-unstable, ... }:

{
  users.users.${username}.extraGroups = [
    "minecraft"
  ];
  services.minecraft-server = {
    enable = true;
    package = pkgs-unstable.minecraftServers.vanilla;
    eula = true;
    openFirewall = true;
    declarative = true;
    dataDir = "/stay/minecraft";
    serverProperties = {
      server-port = port;
      difficulty = 3;
      motd = "Lini's server!";
    };
    jvmOpts = "-Xms4G -Xmx4G";
  };
}
