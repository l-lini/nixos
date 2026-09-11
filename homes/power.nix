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
          "swayidle -w before-sleep 'swaylock' timeout 0 'swaylock'"
        ];
        extra-utility-commands = [
          "exec notify-send -t 3000 \"$(cat /sys/class/power_supply/BAT0/status) $(cat /sys/class/power_supply/BAT0/capacity)%\""
          "exec brightnessctl s 1"
          "exec brightnessctl s 15%"
          "exec brightnessctl s 100%"
        ];
      })
    ]
    ++ [
      inputs.dat566.homeModules.vscode
    ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "25.11";
}
