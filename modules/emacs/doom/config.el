;;; config.el -*- lexical-binding: t; -*-
;;;
;;; Lives at ~/.config/doom/config.el (out-of-store symlink).
;;; Reload after editing with `SPC h r r' - no rebuild needed.

;; Only used for #+AUTHOR in org export. Magit ignores it: commit authorship
;; comes from git's own config, which modules/git generates.
(setq user-full-name "Paulo Haacke")

;;; --- Appearance ---------------------------------------------------------

(setq doom-theme 'doom-one
      display-line-numbers-type t)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

(add-to-list 'default-frame-alist '(width . 140))
(add-to-list 'default-frame-alist '(height . 45))

;;; --- Org ----------------------------------------------------------------
;; `org-directory' must be set here, BEFORE org loads. Everything else that
;; configures org belongs inside `after!' blocks in lisp/ph-org.el.

(setq org-directory "~/org/")

;;; --- Local modules ------------------------------------------------------
;; (load! "lisp/ph-org")
;; (load! "lisp/ph-points")
;; (load! "lisp/ph-ai")
