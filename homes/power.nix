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
        extra-startup = [
          {
            command = "swayidle -w before-sleep 'swaylock' timeout 0 'swaylock'";
            always = true;
          }
        ];
        extra-keybindings = {
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
