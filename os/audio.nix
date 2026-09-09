{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pamixer
  ];

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
