{ ... }:
{
  enable = true;
  enableBashIntegration = true;
  extraOptions = [
    "--group-directories-first"
  ];
  icons = "always"; # Display icons next to file names
  git = true; # List each file's Git status if tracked or ignored
}
