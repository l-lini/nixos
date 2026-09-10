# TODO: Explicit dependencies
{
  extra-assigns ? { },
  extra-keybindings ? { },
  extra-startup ? [ ],
  extra-utility-commands ? [ ],
}:
{
  # TODO: move parameter defaults to a dependency we are abstracted from sway
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
  utility-commands = [
    ''exec notify-send -t 3000 "$(date '+%d %A %H:%M:%S')"''
    "exec slurp | grim -g - - | wl-copy"
  ]
  ++ extra-utility-commands;
  keybindings =
    extra-keybindings
    // {
      "Mod4+Return" = "exec kitty";
      "Mod4+Escape" = "exit";
      "Mod4+Shift+Escape" = "exec poweroff";
      "Mod4+Tab" = "exec systemctl sleep";
      "Mod4+Backspace" = "kill";

      # TODO: Volume keybinds
      # TODO: Mute keybinds

      "Mod4+h" = "focus left";
      "Mod4+l" = "focus right";
      "Mod4+k" = "focus up";
      "Mod4+j" = "focus down";
      "Mod4+Shift+h" = "move left";
      "Mod4+Shift+l" = "move right";
      "Mod4+Shift+k" = "move up";
      "Mod4+Shift+j" = "move down";
      "Mod4+Control+h" = "resize shrink width 10ppt";
      "Mod4+Control+l" = "resize grow width 10ppt";
      "Mod4+Control+k" = "resize grow height 10ppt";
      "Mod4+Control+j" = "resize shrink height 10ppt";

      # TODO: unfocus floating keybind
    }
    # Workspace keybindings
    // builtins.zipAttrsWith (_: builtins.head) (
      builtins.map (workspace: {
        "Mod4+${workspace.key}" =
          (if builtins.hasAttr "command" workspace then "exec ${workspace.command} & swaymsg " else "")
          + "workspace ${workspace.name}";
        "Mod4+Shift+${workspace.key}" = "move to workspace ${workspace.name}";
        "Mod4+Control+${workspace.key}" = "workspace ${workspace.name}";
      }) workspaces
    )
    # Utility command keybindings
    // builtins.zipAttrsWith (_: builtins.head) (
      builtins.map (i: {
        "Mod4+${builtins.toString i}" = builtins.elemAt utility-commands (i - 1);
      }) (builtins.genList (builtins.add 1) (builtins.length utility-commands))
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
