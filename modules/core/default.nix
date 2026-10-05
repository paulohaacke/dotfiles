{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    claude-code
    antigravity-cli
  ];
  systemd.user.startServices = true;
}
