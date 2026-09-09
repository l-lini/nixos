# TODO: Volume keybinds
# TODO: Pavucontrol workspace and keybind
{
  # TODO: Store globally in separate file
  # TODO: Make dependencies on programs explicit
  extra-keybindings ? { },
  extra-assigns ? { },
  extra-startup ? [ ],
}:
{
  ...
}:

let
  keybindings = extra-keybindings // {
    "Mod4+Return" = "exec kitty";
    "Mod4+Space" = "exec wofi --show run";
    "Mod4+Backspace" = "kill";
    "Mod4+h" = "focus left";
    "Mod4+l" = "focus right";
    "Mod4+k" = "focus up";
    "Mod4+j" = "focus down";
    "Mod4+w" =
      ''exec notify-send -t 3000 "$(swaymsg -t get_workspaces -r | jq '.[] | select(.focused) | .name')"'';
    "Mod4+r" = "exec slurp | grim -g - - | wl-copy";
    "Mod4+t" = ''exec notify-send -t 3000 "$(date '+%d %A %H:%M:%S')" '';
    "Mod4+s" = "exec systemctl sleep";
    "Mod4+x" = "layout toggle split";

    "Mod4+f" = "exec firefox & swaymsg workspace f";
    "Mod4+Shift+f" = "move to workspace f";
    "Mod4+q" = "exec qsynth & swaymsg workspace q";
    "Mod4+Shift+q" = "move to workspace q";

    "Mod4+1" = "workspace 1";
    "Mod4+Shift+1" = "move to workspace 1";
    "Mod4+2" = "workspace 2";
    "Mod4+Shift+2" = "move to workspace 2";
    "Mod4+3" = "workspace 3";
    "Mod4+Shift+3" = "move to workspace 3";
  };
  # TODO: Store globally along with keybinds
  assigns = extra-assigns // {
    q = [
      {
        class = "Qsynth";
      }
    ];
    f = [
      {
        app_id = "firefox";
      }
    ];
  };
  startup = extra-startup ++ [
    {
      command = "swaync";
      always = true;
    }
    {
      command = ''notify-send -t 5000 "Welcome!"'';
      always = true;
    }
  ];
in
{
  imports = [
    ./kitty.nix
    ./wofi.nix
  ];

  programs.jq.enable = true;

  services = {
    swaync.enable = true;
    autotiling = {
      enable = true;
      extraArgs = [
        "--splitratio"
        "2"
        "-l"
        "2"
      ];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit startup assigns keybindings;
      bars = [ ];
      defaultWorkspace = "workspace number 1";
      floating = {
        modifier = "Mod4";
        border = 0;
        titlebar = false;
      };
      input."type:touchpad" = {
        natural_scroll = "enabled";
        tap = "enabled";
      };
      window = {
        border = 0;
        titlebar = false;
      };
    };
    xwayland = true;
  };
}
