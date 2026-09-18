{ config, pkgs, ... }:

{
  home.username = "paulo";
  home.homeDirectory = "/home/paulo";
  home.stateVersion = "24.05";

  imports = [
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
      email = "";
      directory = "~/academic/";
    };

    work = {
      fullName = "Paulo Haacke";
      email = "";
      directory = "~/work/";
      sshKey = "~/.ssh/id_work";
    };
  };

  programs.home-manager.enable = true;
}
