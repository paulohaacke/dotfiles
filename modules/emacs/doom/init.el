;;; init.el -*- lexical-binding: t; -*-

;; This file controls which Doom modules are enabled.
;; After editing: run `doom sync` and restart Emacs.
;; Press `SPC h d h' inside Emacs for Doom's own documentation,
;; or put your cursor on a module below and press `K' to read about it.

(doom! :input
       ;;bidi
       ;;chinese
       ;;japanese
       ;;layout

       :completion
       (corfu +orderless)          ; in-buffer completion popup
       (vertico +icons)            ; minibuffer completion (consult, embark)

       :ui
       doom                        ; the default look
       doom-dashboard              ; startup screen
       hl-todo                     ; highlight TODO/FIXME/NOTE
       indent-guides
       modeline
       ophints                     ; visual feedback on yank/delete
       (popup +defaults)           ; the popup window manager you wanted
       vc-gutter                   ; git diff marks in the fringe
       vi-tilde-fringe
       workspaces                  ; per-project window layouts

       :editor
       (evil +everywhere)          ; vim everywhere
       file-templates
       fold
       snippets
       word-wrap

       :emacs
       dired
       electric
       undo
       vc

       :term
       vterm                       ; replaces your tmux panes

       :checkers
       syntax

       :tools
       direnv                      ; picks up per-project nix shells
       (eval +overlay)
       lookup
       lsp
       magit
       pdf
       tree-sitter

       :lang
       emacs-lisp
       (json +lsp)
       latex                       ; thesis writing
       markdown
       nix
       (org +roam2 +pretty +dragndrop)   ; +roam2 is the zettelkasten layer
       (python +lsp +pyright)
       (sh +lsp)
       terraform                   ; IaC
       (yaml +lsp)

       :config
       (default +bindings +smartparens))
