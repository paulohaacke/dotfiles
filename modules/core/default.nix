{ pkgs, ... }:

{
  home.packages = [
    pkgs.neovim
  ];
  systemd.user.startServices = true;
}
