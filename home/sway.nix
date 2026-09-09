# TODO: Explicit dependencies
# TODO: Generate from attribute set
{
  extra-keybindings ? { },
  extra-assigns ? { },
  extra-startup ? [ ],
}:
{
  ...
}:

let
  workspaces = [
    {
      name = "firefox";
      key = "f";
      command = "firefox";
      assignment-criteria = {
        app_id = "firefox";
      };
    }
    {
      name = "pavucontrol";
      key = "p";
      command = "pavucontrol";
      assignment-criteria = {
        app_id = "org.pulseaudio.pavucontrol";
      };
    }
    {
      name = "steam";
      key = "s";
      command = "steam";
      assignment-criteria = {
        class = "steam";
      };
    }
    {
      name = "discord";
      key = "d";
      command = "discord";
      assignment-criteria = {
        class = "discord";
      };
    }
    {
      name = "qsynth";
      key = "q";
      command = "qsynth";
      assignment-criteria = {
        class = "Qsynth";
      };
    }
    {
      # HACK: Had to name it 1 since defaultWorkspace wasn't working
      name = "1";
      key = "Space";
    }
  ];
  keybindings =
    extra-keybindings
    // {
      "Mod4+Return" = "exec kitty";
      "Mod4+Escape" = "exit";
      "Mod4+Shift+Escape" = "exec poweroff";
      "Mod4+Tab" = "exec systemctl sleep";

      # TODO: Kill with force (:< no kittens are safe from my wrath muhahahah
      "Mod4+Backspace" = "kill";

      # TODO: Volume keybinds
      # TODO: Mute keybinds

      # TODO: move keybinds
      # TODO: resize keybinds
      "Mod4+h" = "focus left";
      "Mod4+l" = "focus right";
      "Mod4+k" = "focus up";
      "Mod4+j" = "focus down";

      # TODO: unfocus floating keybind

      # TODO: generate from a list of utility commands
      # (makes for an easy interface to add utility commands)
      "Mod4+1" = ''exec notify-send -t 3000 "$(date '+%d %A %H:%M:%S')" '';
      "Mod4+2" = "exec slurp | grim -g - - | wl-copy";

      # TODO: Fix this keybind or just add move keybinds
      # "Mod4+x" = "layout toggle split";
    }
    // builtins.zipAttrsWith (_: builtins.head) (
      builtins.map (workspace: {
        "Mod4+${workspace.key}" =
          (if builtins.hasAttr "command" workspace then "exec ${workspace.command} & swaymsg " else "")
          + "workspace ${workspace.name}";
        "Mod4+Shift+${workspace.key}" = "move to workspace ${workspace.name}";
      }) workspaces
    );
  assigns =
    extra-assigns
    // builtins.listToAttrs (
      builtins.map (workspace: {
        name = workspace.name;
        value = [ workspace.assignment-criteria ];
      }) (builtins.filter (builtins.hasAttr "assignment-criteria") workspaces)
    );
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
