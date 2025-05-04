{ ... }:

{
  enable = true;

  config = {
    borderless = true;
    tab_position = "hidden";
    window_state = "maximise";

    profiles.default = {
      use_system_font = false;
      font = "JetBrainsMono Nerd Font 10";
      background_type = "transparent";
      background_darkness = 0.85;
      show_titlebar = false;
      scrollback_lines = 2000;
    };
  };
}
