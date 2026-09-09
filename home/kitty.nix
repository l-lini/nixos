{ color, config, ... }:

{
  programs.zsh.initContent = config.programs.zsh.shellInit;

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      font_family = "Comic Mono";
      font_style = "Bold";
      font_size = 19.0;
      # clear_all_mouse_actions = "yes";
    };
  };
}
