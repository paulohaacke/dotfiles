# @emacs@ is replaced with the wrapped Emacs store path by default.nix.
# No shebang: writeShellScript prepends one.
#
# The daemon is started by systemd (socket activation), and its environment
# comes from systemd.user.services.emacs in default.nix - not from here.
# The sourcing below only affects this client process.
 
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
 
export PATH="$HOME/.nix-profile/bin:$PATH"
 
exec @emacs@/bin/emacsclient -c "$@"

