{ ... }:

{
  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];

    initExtra = ''
      PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '

      ${builtins.readFile ./host-bootstrap.sh}
    '';
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
}
