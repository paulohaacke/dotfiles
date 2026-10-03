{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    claude-code
  ];
  systemd.user.startServices = true;
}
