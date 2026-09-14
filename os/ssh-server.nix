{
  port,
  interface,
  address,
  defaultGateway ?
    with builtins;
    let
      xs = splitVersion address;
      x = elemAt xs;
      xs' = map x (genList (x: x) 3) ++ [ "1" ];
    in
    concatStringsSep "." xs',
  nameservers ? [
    "1.1.1.1"
  ],
}:

{
  services.openssh = {
    enable = true;
    ports = [ port ];

    hostKeys = [
      {
        bits = 4096;
        openSSHFormat = true;
        path = "/home/lini/.ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/home/lini/.ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  networking = {
    inherit nameservers defaultGateway;

    firewall = {
      enable = true;
      allowedTCPPorts = [ port ];
    };

    interfaces.${interface}.ipv4.addresses = [
      {
        address = address;
        prefixLength = 24;
      }
    ];
  };
}
