{ config, pkgs, lib, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  emacsPkg = config.programs.emacs.finalPackage;
  emacsDir  = "${config.home.homeDirectory}/.config/emacs";
  doomDir   = "${config.home.homeDirectory}/.config/doom";
  doomBin   = "${emacsDir}/bin/doom";
  stampFile = "${config.xdg.dataHome}/doom-nix/sync.stamp";
  doomRepo = "https://github.com/doomemacs/doomemacs";
  systemctl = config.systemd.user.systemctlPath;

  emacsLaunch = pkgs.writeShellScript "emacs-launch"
    (builtins.replaceStrings [ "@emacs@" ] [ "${emacsPkg}" ]
      (builtins.readFile ./emacs-launch.sh));
  # Hash of exactly the files whose contents require a `doom sync`
  syncHash = builtins.hashString "sha256" (
    builtins.readFile ./doom/init.el
    + builtins.readFile ./doom/packages.el
  );
  # PATH for the activation script only - what `doom sync` itself shells out to.
  doomPath = lib.makeBinPath ([ emacsPkg ] ++ (with pkgs; [
    git ripgrep fd coreutils gnutls bash
  ]));
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs; #pkgs.emacs-pgtk;
    extraPackages = epkgs: with epkgs; [
      # Only packages with native code belong here; everything else stays in
      # doom/packages.el. Each one also needs `:built-in 'prefer` there.
      vterm
    ];
  };
  
  services.emacs = {
    enable = true;
    package = emacsPkg;
    defaultEditor = true;
    socketActivation.enable = true;
  };

  systemd.user.services.emacs.Service.Environment = [
    "PATH=${config.home.profileDirectory}/bin:${emacsDir}/bin:/usr/local/bin:/usr/bin:/bin"
    "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt" 
    "DOOMDIR=${doomDir}"
    "EMACSDIR=${emacsDir}"
  ];
  
  home.sessionPath = [ "${emacsDir}/bin" ];

  home.sessionVariables = {
    DOOMDIR = doomDir;
    EMACSDIR = emacsDir;
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
    nixfmt
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

  # Bootstrap and sync Doom automatically
  home.activation.doom = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    export PATH="${doomPath}:$PATH"
    export DOOMDIR="${doomDir}"
    export EMACSDIR="${emacsDir}"

    if [ ! -f "${doomDir}/init.el" ]; then
      echo "doom: ERROR ${doomDir}/init.el not found (broken symlink?)." >&2
      echo "doom: check dotfilesDir in modules/emacs/default.nix." >&2
      exit 1
    fi

    writeStamp() {
      mkdir -p "$(dirname "${stampFile}")"
      printf '%s' "${syncHash}" > "${stampFile}"
    }
  
    restartDaemon() {
      $DRY_RUN_CMD ${systemctl} --user try-restart emacs.service || true
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
          restartDaemon
        else
          echo "doom: install failed. Run '${doomBin} install' manually." >&2
        fi
      fi
    elif [ "$(cat "${stampFile}" 2>/dev/null || true)" != "${syncHash}" ]; then
      echo "doom: init.el or packages.el changed, syncing..."
      if $DRY_RUN_CMD ${doomBin} sync; then
        writeStamp
        restartDaemon
      else
        echo "doom: sync failed (offline?). Run 'doom sync' manually." >&2
      fi
    fi
  '';

  # Out-of-store symlink: ~/.config/doom points at the real repo directory, so
  # `SPC f p` -> edit -> `SPC h r r` reloads without `home-manager switch`.
  # Swap for `xdg.configFile."doom".source = ./doom;` if you would rather have
  # it immutable in the Nix store (then every edit needs a rebuild).
  xdg.configFile."doom".source = 
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/emacs/doom";

  home.file.".local/bin/ec".source = emacsLaunch;

  xdg.desktopEntries.emacsclient-nix = {
    name = "Emacs";
    exec = "${emacsLaunch} %F";
    icon = "emacs";
    terminal = false;
    categories = [ "Development" "TextEditor" ];
    mimeType = [ "text/plain" "text/x-org" "inode/directory" ];
    settings.StartupWMClass = "Emacs";
  };
}
