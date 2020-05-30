;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Mike Vanbuskirk"
      user-mail-address "mike@mikevanbuskirk.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Source Code Pro For Powerline" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-material)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-local "~/Documents/org/")
(setq org-shared "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/")
(setq org-agenda-files (list org-local
			     (concat org-shared "inbox.org")))
(setq org-refile-targets '((nil :maxlevel . 9)
      (org-agenda-files :maxlevel . 9)))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; General config
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
(setq shell-file-name "/usr/local/bin/zsh")
(global-auto-revert-mode t)

;; Org config
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-return-follows-link t)
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

(setq org-capture-templates
      `(("w" "Work Task" entry (file+headline ,(concat org-local "inbox.org") "Tasks")
	 "* TODO %?")
	("n" "Work Note" entry (file+headline ,(concat org-local "inbox.org") "Notes")
	 "* %?")
	("t" "Personal Todo" entry (file+headline ,(concat org-shared "inbox.org") "To-do")
	 "* TODO %?")
	("c" "Code Task" entry (file+headline ,(concat org-local "inbox.org") "Tasks")
	 "* TODO %?\n %i\n  %a")
	("l" "link" entry (file+headline, (concat org-shared "inbox.org") "Resources")
	 "** TODO %(org-cliplink-capture) \n CREATED: %t\n" :immediate-finish t)))

;; Org cliplink
(use-package! org-cliplink)

;; Org roam
(use-package! org-roam
  :after org
  :hook
  (after-init . org-roam-mode)
  :init
  (setq org-roam-directory (concat org-shared "2b/org")
        org-roam-db-location "~/org-roam.db"))
