;;; config.el -*- lexical-binding: t; -*-
 
;; Personal identity, used by magit and org export.
(setq user-full-name "Paulo Haacke")
 
;;; --- Appearance ---------------------------------------------------------
 
(setq doom-theme 'doom-one
      display-line-numbers-type t)
 
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))
 
;;; --- Org ----------------------------------------------------------------
;; `org-directory' must be set here, BEFORE org loads. Everything else that
;; configures org belongs inside `after!' blocks, which is why it lives in
;; lisp/ph-org.el instead.
 
(setq org-directory "~/org/")
 
;;; --- Local modules ------------------------------------------------------
;; `load!' is Doom's macro for loading a file relative to this one.
;; Same modular idea as before: one concern per file, explicit load order.
 
;; (load! "lisp/ph-org")
;; (load! "lisp/ph-points")   ; uncomment once written
;; (load! "lisp/ph-ai")       ; gptel etc.

