{ ... }: {
  programs.kitty.enable = true;     # installs it
  programs.yazi.enable = true;

  xdg.configFile."kitty".source = ./config/kitty;
  xdg.configFile."yazi".source = ./config/yazi;
}
