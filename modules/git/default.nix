{ config, pkgs, ... }:

{  
  programs.git = {
    enable = true;
    settings.user = {
      name = "Paulo Haacke";
      email = "paulohaacke@gmail.com";
    };
  };
}

