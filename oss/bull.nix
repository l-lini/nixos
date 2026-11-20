{ ... }@args:

{
  _module.args = {
    disk-device = "/dev/disk/by-id/nvme-Samsung_SSD_980_250GB_S64BNU0TA06655V";
    disk-encryption = null;
    hostId = "68617465";
  };

  imports =
    builtins.map (x: ./../os + x) [
      /autologin.nix
      /immich.nix
      /radicale.nix
      /allow-unfree.nix
      /networking.nix
      /nix.nix
      /git.nix
      /users.nix
      /hardware.nix
      /packages.nix
      /zoxide.nix
      /boot.nix
      /zsh.nix
      /console.nix
      /disko.nix
      /neovim
    ]
    ++ [
      (import ./../os/minecraft-server.nix {
        port = 1337;
      })
      (import ./../os/ssh-server.nix {
        port = 42069;
        interface = "enp5s0";
        address = "10.20.51.26";
      })
    ];

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.11";
}
