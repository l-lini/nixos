{
  inputs,
  disk-encryption,
  disk-device,
  ...
}:

{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = disk-device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
        };
        datasets = {
          "nixos/empty" = {
            type = "zfs_fs";
            options = {
              mountpoint = "legacy";
            }
            // (
              if builtins.isString disk-encryption then
                {
                  encryption = disk-encryption;
                  keylocation = "prompt";
                  keyformat = "passphrase";
                }
              else
                { }
            );
            mountpoint = "/";
            postCreateHook = "zfs snapshot rpool/nixos/empty@start";
          };
          "nixos/home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          # TODO: remove and switch to sops.nix
          "nixos/stay" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/stay";
          };
          "nixos/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
        };
      };
    };
  };
}
