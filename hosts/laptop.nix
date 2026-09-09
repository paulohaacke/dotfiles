{ config, pkgs, ... }:

{
  home.username = "paulo";
  home.homeDirectory = "/home/paulo";
  home.stateVersion = "24.05";

  imports = [
    ../modules/core
    ../modules/git
    ../modules/emacs
  ];

  programs.home-manager.enable = true;
}
