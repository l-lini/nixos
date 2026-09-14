{
  extra-assigns ? { },
  extra-startup ? [ ],
  extra-utility-commands ? [ ],
}:
{
  # TODO: move parameter defaults to a dependency we are abstracted from sway
  lib,
  config,
  ...
}:

let
  # TODO: dependencies for all of these (add an attribute
  # for dependency package i guess)

  # TODO: error for repeated use of keys
  workspaces = [
    (
      let
        version = "26.2";
      in
      {
        name = "minecraft";
        key = "m";
        command = "prismlauncher --launch ${version}";
        assignment-criteria = {
          class = "Minecraft ${version}";
        };
      }
    )
    {
      name = "minitube";
      key = "y";
      command = "minitube";
      assignment-criteria = {
        app_id = "org.tordini.flavio.";
      };
    }
    {
      name = "prismlauncher";
      key = "r"; # TODO: Better key
      command = "prismlauncher";
      assignment-criteria = {
        app_id = "org.prismlauncher.PrismLauncher";
      };
    }
    {
      name = "prusa slicer";
      key = "c";
      command = "prusa-slicer & wezterm";
      assignment-criteria = {
        app_id = "prusa-slicer";
      };
    }
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
      name = "1";
      key = "Space";
    }
  ];
  utility-commands = [
    "exec notify-send -t 3000 \"$(date '+%d %A %H:%M:%S')\"" # TODO: Dependency on swaync/mako
    "exec notify-send -t 3000 \"$(nmcli -f NAME,TYPE -c no connection show --active | grep --color=never -E 'wifi|ethernet')\"" # TODO: depencency on nmcli (networkmanager)
    "exec slurp | grim -g - - | wl-copy" # TODO: dependency on grim and slurp

    # TODO: dependencies on pactl (idk what package it comes from, look it up)
    "exec pactl set-sink-volume $(pactl get-default-sink) -20%"
    "exec pactl set-sink-volume $(pactl get-default-sink) +20%"
    "exec pactl set-sink-mute $(pactl get-default-sink) toggle"
  ]
  ++ extra-utility-commands;
  keybindings = {
    "Mod4+Return" = "exec wezterm"; # TODO: consider putting this in workspace 1
    "Mod4+Escape" = "exit";
    "Mod4+Shift+Escape" = "exec poweroff";
    "Mod4+Tab" = "exec systemctl sleep";
    "Mod4+Backspace" = "kill";

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
  }
  # Workspace keybindings
  // builtins.zipAttrsWith (_: builtins.head) (
    builtins.map (workspace: {
      # TODO: only run command if the assignment-criteria is not
      # fullfilled in this workspace
      "Mod4+${workspace.key}" =
        (if builtins.hasAttr "command" workspace then "exec ${workspace.command} & swaymsg " else "")
        + "workspace ${workspace.name}";
      "Mod4+Shift+${workspace.key}" = "move to workspace ${workspace.name}";
      "Mod4+Control+${workspace.key}" = "workspace ${workspace.name}";
    }) workspaces
  )
  # Utility command keybindings
  // builtins.zipAttrsWith (_: builtins.head) (
    builtins.map (
      i':
      let
        key =
          if i' == 10 then
            "0"
          else
            # TODO: Consider generating more than 10 keybinds
            builtins.toString i';
      in
      {
        "Mod4+${key}" = builtins.elemAt utility-commands (i' - 1);
      }
    ) (builtins.genList (builtins.add 1) (builtins.length utility-commands))
  );
  assigns =
    extra-assigns
    # Workspace assignments
    // builtins.listToAttrs (
      builtins.map (workspace: {
        name = workspace.name;
        value = [ workspace.assignment-criteria ];
      }) (builtins.filter (builtins.hasAttr "assignment-criteria") workspaces)
    );
  startup =
    map
      (command: {
        inherit command;
        always = true;
      })
      (
        extra-startup
        ++ [
          "swaync"
          "notify-send -t 5000 \"Welcome!\""
        ]
      );
in
{
  programs.jq.enable = true;

  # Terminal. TODO: Move sway into directory and this into a submodule
  programs.zsh.initContent = config.programs.zsh.shellInit;
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font_size = 16
      config.font = wezterm.font("Comic Mono")
      config.enable_tab_bar = false
      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      return config
    '';
  };

  services = {
    mako = {
      enable = true;
      settings = {
        background-color = "#000000";
        border-size = 0;
        padding = 10;
        font = "Comic Mono 16";
        margin = 0;
        width = 480;
        # TODO: default timer
      };
    };
    autotiling = {
      enable = true;
      extraArgs = [
        "--splitratio"
        "1"
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
      focus.followMouse = false;
    };
    xwayland = true;
  };
}
