{ config, pkgs, ... }:

{
  home.file.".config/emacs/early-init.el".source = ./early-init.el;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.magit
      epkgs.doom-themes
    ];
    extraConfig = builtins.readFile ./emacs-config.el;
  };
}
