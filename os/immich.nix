{ ... }:

{
  services.immich = {
    enable = true;
    port = 1338;
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/home/lini/immich";
  };
}
