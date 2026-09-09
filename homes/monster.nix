{ username, homeDirectory, ... }:

{
  imports =
    builtins.map (x: ./../home/${x}) [
      /keyd.nix
      /kitty.nix
      /wofi.nix
    ]
    ++ [
      (import ./../home/sway.nix {
        sway-workspaces = {
          "1" = null;
          "2" = null;
          "3" = null;
        };
      })
    ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.11";
}
