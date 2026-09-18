# Launcher for the desktop entry.
# @emacs@ is substituted with the wrapped Emacs store path by default.nix.
# No shebang: writeShellScript prepends one.

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export PATH="$HOME/.nix-profile/bin:$PATH"

exec @emacs@/bin/emacsclient -c -a "" "$@"
