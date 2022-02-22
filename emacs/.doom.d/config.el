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
(setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Hack Nerd Font Mono" :size 14))
(setq doom-themes-treemacs-theme "doom-colors")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-local "~/Documents/org/")
(setq org-pkm "~/Dropbox/beorg/org/")
(setq org-projects "~/Dropbox/org/")
(setq org-agenda-files (list org-local (concat org-projects "freelance/")
                       (concat org-pkm "inbox.org")
                       (concat org-projects "projects.org")))
(setq org-refile-targets '((nil :maxlevel . 9)
      (org-agenda-files :maxlevel . 9)))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(apply #'set-face-attribute '(line-number nil :foreground "#B0BEC5"))

;; General config
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
(setq shell-file-name "/usr/bin/zsh")
(global-auto-revert-mode t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Org config
(after! org
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-refile-use-outline-path t)
  (setq org-hide-emphasis-markers t)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-return-follows-link t)
  (setq org-clock-into-drawer t)
  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

  (setq org-capture-templates
        `(("w" "Work Task" entry (file+headline ,(concat org-local "inbox.org") "Tasks")
  	 "* TODO %?")
  	("n" "Work Note" entry (file+headline ,(concat org-local "inbox.org") "Notes")
  	 "* %?")
  	("t" "Personal Todo" entry (file+headline ,(concat org-pkm "inbox.org") "To-do")
  	 "* TODO %?")
  	("c" "Code Task" entry (file+headline ,(concat org-local "inbox.org") "Tasks")
  	 "* TODO %?\n %i\n  %a")
  	("l" "link" entry (file+headline, (concat org-pkm "inbox.org") "Resources")
  	 "** TODO %(org-cliplink-capture) \n CREATED: %t\n" :immediate-finish t))))

; Org cliplink
(use-package! org-cliplink
  :after org)

;; Org roam
(use-package! org-roam
  :after org
  :init
  (setq org-roam-directory (file-truename (concat org-pkm "2b/org"))))
