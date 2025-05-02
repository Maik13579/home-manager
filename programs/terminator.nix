{ pkgs, ... }:

{
  enable = true;
  
  config = {
    borderless = true;
    tab_position = "hidden";
    window_stare = "maximise";

    profiles.default = {
        background_type = "transparent";
        background_darkness = 0.85;
        show_titlebar = false;
        scrollback_lines = 2000;
     };
  };
}