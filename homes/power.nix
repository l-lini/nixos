{
  inputs,
  username,
  homeDirectory,
  ...
}:

{
  imports =
    builtins.map (x: ./../home/${x}) [
      /kitty.nix
      /swayidle.nix
      /keyd.nix
      /swaylock.nix
      /wofi.nix
    ]
    ++ [
      (import ./../home/sway.nix {
        sway-workspaces = {
          "1" = null;
          "2" = null;
          "3" = null;
        };
        sway-startup = [
          {
            command = "swayidle -w before-sleep 'swaylock' timeout 0 'swaylock'";
            always = true;
          }
          {
            command = "autotiling -l 1";
            always = true;
          }
        ];
        sway-keybinds = {
          "Mod4+a" =
            ''exec notify-send -t 3000 "$(cat /sys/class/power_supply/BAT0/status) $(cat /sys/class/power_supply/BAT0/capacity)%"'';
        };
      })
    ]
    ++ [
      inputs.dat566.homeModules.vscode
    ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.11";
}
