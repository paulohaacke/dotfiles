enter-nix() {
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
  export PATH="$HOME/.nix-profile/bin:$PATH"
  echo "❄️  Nix environment activated!"
}
