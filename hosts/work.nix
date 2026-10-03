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

  my.defaultIdentity = "work";

  my.identities = {
    work = {
      fullName = "Paulo Haacke";
      includeFile = "~/.config/git/work-identity";
      sshKey = "~/.ssh/id_work";
    };

    academic = {
      fullName = "Paulo Haacke";
      includeFile = "~/.config/git/academic-identity";
      directory = "~/academic/";
    };

    personal = {
      fullName = "Paulo Haacke";
      email = "paulohaacke@gmail.com";
      directory = "~/work/";
    };
  };

  programs.home-manager.enable = true;
}
