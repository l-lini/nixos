{ inputs, ... }@args:

{
  _module.args = {
    disk-device = "/dev/disk/by-id/nvme-SSSTC_CL1-8D256-HP_UKFCN01ZTF95EW";
    disk-encryption = "aes-256-gcm";
    disk-filesystem = "zfs";
    hostId = "b000b135";
  };

  imports = builtins.map (x: ./../os + x) [
    /home-manager.nix
    /sudo.nix
    /docker.nix
    /alias.nix
    /lid.nix
    /keyd.nix
    /allow-unfree.nix
    /autologin.nix
    /networking.nix
    /battery.nix
    /sway.nix
    /fonts.nix
    /network-manager.nix
    /audio.nix
    /git.nix
    /github.nix
    /nix.nix
    /users.nix
    /hardware.nix
    /packages.nix
    /zoxide.nix
    /boot.nix
    /printing.nix
    /zsh.nix
    /console.nix
    /ssh-client.nix
    /disko.nix
    /neovim
  ];

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.11";
}
