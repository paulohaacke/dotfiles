{ config, pkgs, ... }:

{
  home.username = "paulo";
  home.homeDirectory = "/home/paulo";
  home.stateVersion = "24.05";

  imports = [
    ../modules/bash
    ../modules/nix
    ../modules/identity
    ../modules/core
    ../modules/git
    ../modules/emacs
  ];

  my.defaultIdentity = "personal";

  my.identities = {
    personal = {
      fullName = "Paulo Haacke";
      email = "paulohaacke@gmail.com";
    };

    academic = {
      fullName = "Paulo Haacke";
      includeFile = "~/.config/git/academic-identity";
      directory = "~/academic/";
    };
  };

  programs.home-manager.enable = true;
}
