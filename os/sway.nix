{ pkgs, ... }:

{
  programs = {
    steam.enable = true;
    sway.enable = true;
  };

  # Autostart sway
  environment.loginShellInit = "[[ \"$(tty)\" == /dev/tty1 ]] && sway";

  environment.systemPackages = with pkgs; [
    prismlauncher
    obsidian
    clonehero
    jq
    qsynth
    minitube
    spotify
    prismlauncher
    heroic
    r2modman
    prusa-slicer
    pavucontrol
    inkscape
    mupdf
    grim
    slurp
    wl-clipboard
    discord
    slack
    libnotify
    firefox
    qutebrowser
  ];
}
