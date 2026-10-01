;;; init.el -*- lexical-binding: t; -*-

;; Lives at ~/.config/doom/init.el (out-of-store symlink).
;; Editing this triggers `doom sync' on the next home-manager switch.
;; Put the cursor on a module and press `K' to read its documentation.

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
       dashboard                   ; startup screen (doom-dashboard before 2.1)
       hl-todo                     ; highlight TODO/FIXME/NOTE
       indent-guides
       modeline
       ophints                     ; visual feedback on yank/delete
       (popup +defaults)           ; popup window management
       treemacs
       (vc-gutter +pretty)         ; git diff marks in the fringe
       vi-tilde-fringe
       workspaces                  ; per-project window layouts

       :editor
       (evil +everywhere)          ; vim everywhere
       file-templates
       fold
       snippets
       (whitespace +guess +trim)
       word-wrap

       :emacs
       dired
       electric
       tramp
       undo
       vc

       :term
       vterm                       ; replaces tmux panes
       ghostel

       :checkers
       syntax

       :tools
       ansible
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
