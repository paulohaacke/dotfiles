{ config, pkgs, lib, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  emacsPkg = config.programs.emacs.finalPackage;
  emacsDir  = "${config.home.homeDirectory}/.config/emacs";
  emacsLaunch = pkgs.writeShellScript "emacs-launch"
    (builtins.replaceStrings [ "@emacs@" ] [ "${emacsPkg}" ]
      (builtins.readFile ./emacs-launch.sh));
  doomDir   = "${config.home.homeDirectory}/.config/doom";
  doomBin   = "${emacsDir}/bin/doom";
  stampFile = "${config.xdg.dataHome}/doom-nix/sync.stamp";
  doomRepo = "https://github.com/doomemacs/doomemacs";
  # Hash of exactly the files whose contents require a `doom sync`
  syncHash = builtins.hashString "sha256" (
    builtins.readFile ./doom/init.el
    + builtins.readFile ./doom/packages.el
  );
  doomPath = lib.makeBinPath ([ emacsPkg ] ++ (with pkgs; [
    git ripgrep fd coreutils gnutls bash
  ]));
in
{
  # Out-of-store symlink: ~/.config/doom points at the real repo directory, so
  # `SPC f p` -> edit -> `SPC h r r` reloads without `home-manager switch`.
  # Swap for `xdg.configFile."doom".source = ./doom;` if you would rather have
  # it immutable in the Nix store (then every edit needs a rebuild).
  xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/emacs/doom";

  xdg.desktopEntries.emacsclient-nix = {
    name = "Emacs";
    exec = "${emacsLaunch} %F";
    icon = "emacs";
    terminal = false;
    categories = [ "Development" "TextEditor" ];
    mimeType = [ "text/plain" "text/x-org" "inode/directory" ];
    settings.StartupWMClass = "Emacs";
  };

  home.sessionPath = [ "${emacsDir}/bin" ];

  home.sessionVariables = {
    DOOMDIR = "${config.home.homeDirectory}/.config/doom";
    EMACSDIR = "${config.home.homeDirectory}/.config/emacs";
  };

  home.packages = with pkgs; [
    # Required by Doom
    git
    ripgrep
    fd
    coreutils

    # Needed by the modules enabled in init.el
    sqlite
    graphviz
    pandoc
    imagemagick
    zstd
    editorconfig-core-c
    gnutls

    # Language tooling (:lang modules)
    nixd
    nixfmt-rfc-style
    python3
    pyright
    bash-language-server
    shellcheck
    yaml-language-server
    terraform
    terraform-ls
    ansible
    ansible-language-server
    texliveMedium

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.enable = true;

  services.emacs = {
    enable = true;
    package = emacsPkg;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };

  # Bootstrap and sync Doom automatically
  home.activation.doom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${doomPath}:$PATH"
    export DOOMDIR="${doomDir}"
    export EMACSDIR="${emacsDir}"

    writeStamp() {
      mkdir -p "$(dirname "${stampFile}")"
      printf '%s' "${syncHash}" > "${stampFile}"
    }

    if [ ! -d "${emacsDir}/.git" ]; then
      if [ -e "${emacsDir}" ]; then
        echo "doom: ${emacsDir} exists but is not a git checkout." >&2
        echo "doom: move it aside and switch again to install Doom." >&2
      else
        echo "doom: installing Doom Emacs (this takes a few minutes)..."
        $DRY_RUN_CMD git clone --depth 1 ${doomRepo} "${emacsDir}"
        if $DRY_RUN_CMD ${doomBin} install --no-config --no-env --force; then
          writeStamp
        else
          echo "doom: install failed. Run '${doomBin} install' manually." >&2
        fi
      fi
    elif [ "$(cat "${stampFile}" 2>/dev/null || true)" != "${syncHash}" ]; then
      echo "doom: init.el or packages.el changed, syncing..."
      if $DRY_RUN_CMD ${doomBin} sync; then
        writeStamp
      else
        echo "doom: sync failed (offline?). Run 'doom sync' manually." >&2
      fi
    fi
  '';

}
