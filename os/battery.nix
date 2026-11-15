{ pkgs, ... }:

{
  systemd.user = {
    services.low-battery = {
      enable = true;
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = pkgs.writeShellScript "low-battery" ''
          capacity=$(cat /sys/class/power_supply/BAT0/capacity)
          status=$(cat /sys/class/power_supply/BAT0/status)
          if (( $capacity <= 10 )) && [[ "Charging" != $status ]];
          then ${pkgs.lib.getExe pkgs.pkgs.libnotify} -t 60000 "FYI: I am dying";
          fi;
        '';
      };
    };
    timers.low-battery = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* *:*:00";
        Unit = "low-battery.service";
      };
    };
  };
}
