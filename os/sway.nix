{ pkgs, ... }:

{
  programs = {
    steam.enable = true;
    sway.enable = true;
  };

  # Autostart sway
  environment.loginShellInit = "[[ \"$(tty)\" == /dev/tty1 ]] && sway";

  environment.systemPackages = with pkgs; [
    qsynth
    minitube
    prismlauncher
    r2modman # TODO: workspace
    prusa-slicer
    pavucontrol
    inkscape # TODO: workspace
    mupdf
    grim
    slurp
    wl-clipboard
    discord
    slack
    libnotify
    firefox
  ];
}
