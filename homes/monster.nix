{ username, homeDirectory, ... }:

{
  imports =
    builtins.map (x: ./../home/${x}) [
      /keyd.nix
      /kitty.nix
    ]
    ++ [
      (import ./../home/sway.nix { })
    ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.11";
}
