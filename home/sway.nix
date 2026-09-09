# TODO: Volume keybinds
# TODO: Pavucontrol workspace and keybind
{
  sway-workspaces ? {
    "1" = null;
    "2" = null;
    "3" = null;
  },
  sway-startup ? [ ],
  sway-keybinds ? { },
}:
{
  lib,
  ...
}:

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
      startup = [
        {
          command = "swaync";
          always = true;
        }
        {
          command = ''notify-send -t 5000 "Welcome!"'';
          always = true;
        }
      ]
      ++ sway-startup;
      assigns =
        with builtins;
        mapAttrs (_: app: [
          { class = lib.toUpper (substring 0 1 app) + substring 1 (stringLength app - 1) app; }
        ]) (lib.filterAttrs (_: s: isString s) sway-workspaces);
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
      keybindings =
        with builtins;
        let
          generator =
            nameF: valueF: xs:
            listToAttrs (
              map (x: {
                name = nameF x;
                value = valueF x;
              }) xs
            );
          workspaces = attrNames sway-workspaces;
        in
        {
          "Mod4+Return" = "exec kitty";
          "Mod4+Space" = "exec wofi --show run";
          "Mod4+b" = "exec firefox";
          "Mod4+p" = "exec firefox --private-window";
          "Mod4+Backspace" = "kill";
          "Mod4+h" = "focus left";
          "Mod4+l" = "focus right";
          "Mod4+k" = "focus up";
          "Mod4+j" = "focus down";
          "Mod4+w" =
            ''exec notify-send -t 3000 "$(swaymsg -t get_workspaces -r | jq '.[] | select(.focused) | .num')"'';
          "Mod4+r" = "exec slurp | grim -g - - | wl-copy";
          "Mod4+t" = ''exec notify-send -t 3000 "$(date '+%d %A %H:%M:%S')" '';
          "Mod4+s" = "exec systemctl sleep";
          "Mod4+x" = "layout toggle split";
        }
        // generator (n: "Mod4+${n}") (n: "workspace number ${n}") workspaces
        // generator (n: "Mod4+Shift+${n}") (n: "move to workspace number ${n}") workspaces
        // sway-keybinds;
      window = {
        border = 0;
        titlebar = false;
      };
    };
    xwayland = true;
  };
}
