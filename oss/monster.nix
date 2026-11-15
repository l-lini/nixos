{ ... }@args:

{
  _module.args = {
    disk-device = "/dev/disk/by-id/nvme-KINGSTON_SKC3000D2048G_50026B76860D859A";
    disk-encryption = null;
    hostId = "6c6f7665";
  };

  imports = builtins.map (x: ./../os + x) [
    /adb.nix
    /sudo.nix
    /keyd.nix
    /tmux.nix
    /docker.nix
    /alias.nix
    /allow-unfree.nix
    /autologin.nix
    /home-manager.nix
    /networking.nix
    /network-manager.nix
    /sway.nix
    /fonts.nix
    /audio.nix
    /git.nix
    /github.nix
    /nix.nix
    /users.nix
    /hardware.nix
    /packages.nix
    /zoxide.nix
    /boot.nix
    /zsh.nix
    /console.nix
    /ssh-client.nix
    /disko.nix
    /neovim
  ];
  # ++ [
  #   inputs.dat566.nixosModules.default
  # ];

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.11";
}
