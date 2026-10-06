;;; config.el -*- lexical-binding: t; -*-
;;;
;;; Lives at ~/.config/doom/config.el (out-of-store symlink).
;;; Reload after editing with `SPC h r r' - no rebuild needed.

;; Only used for #+AUTHOR in org export. Magit ignores it: commit authorship
;; comes from git's own config, which modules/git generates.
(setq user-full-name "Paulo Haacke")

;;; --- Appearance ---------------------------------------------------------
(setq doom-theme 'doom-one display-line-numbers-type t)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

(add-to-list 'default-frame-alist '(width . 140))
(add-to-list 'default-frame-alist '(height . 45))

;; emacsclient frames reopen the last-used workspace with its saved layout
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override t
        persp-interactive-init-frame-behaviour-override t))

;;; --- Org ----------------------------------------------------------------
;; `org-directory' must be set here, BEFORE org loads. Everything else that
;; configures org belongs inside `after!' blocks in lisp/ph-org.el.

(setq org-directory "~/org/")

;;; --- AI -----------------------------------------------------------------
(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu)
  :init
  (setq claude-code-ide-terminal-backend 'ghostel)
  :config
  ;; Let Claude use Emacs features (xref, project, diagnostics) over MCP.
  (claude-code-ide-emacs-tools-setup))
(use-package! ai-code
  :commands (ai-code-menu)
  :config
  (setq ai-code-backends-infra-terminal-backend 'ghostel)
  (ai-code-set-backend 'antigravity))
(map! :leader :desc "AI code menu" "j a" #'ai-code-menu)

;;; --- Local modules ------------------------------------------------------
;; (load! "lisp/ph-org")
;; (load! "lisp/ph-points")
;; (load! "lisp/ph-ai")
