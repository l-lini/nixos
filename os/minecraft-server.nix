{ port }:
{ pkgs-unstable, ... }:

{
  services.minecraft-server = {
    enable = true;
    package = pkgs-unstable.minecraftServers.vanilla;
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      server-port = port;
      difficulty = 3; # Hard
    };
    jvmOpts = "-Xms4G -Xmx4G";
  };
}
