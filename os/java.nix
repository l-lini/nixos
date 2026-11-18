{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };
  environment.systemPackages = [ pkgs.maven ];
}
