;;; packages.el -*- no-byte-compile: t; -*-
 
;; Extra packages beyond what the modules in init.el already provide.
;; After editing: run `doom sync` and restart Emacs.
;;
;; NOTE: these are fetched by straight.el at `doom sync' time, NOT by Nix.
;; That is the tradeoff of this setup: your config is declarative, but package
;; versions are resolved at sync time rather than pinned by flake.lock.

(package! vterm :built-in 'prefer)

;; AI: chat + inline assistance, supports Claude among other backends.
(package! gptel)
 
;; Uncomment when you set up the bibliography workflow for the thesis:
;; (package! org-roam-bibtex)
;; (package! citar)
;; (package! citar-org-roam)

