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
(setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-oceanic-next)
(setq doom-themes-treemacs-theme "doom-colors")

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

;; Org cliplink
(use-package! org-cliplink
  :after org)

;; Org roam
(use-package! org-roam
  :after org
  :hook
  (after-init . org-roam-mode)
  :init
  (setq org-roam-directory (concat org-pkm "2b/org")
        org-roam-completion-everywhere t
        org-roam-db-location "~/org-roam.db"
        org-roam-graph-executable "/usr/bin/neato"
        org-roam-graph-extra-config '(("overlap" . "false") ("splines" . "false"))
        org-roam-graph-exclude-matcher '("finished" "blog" "podcast" "article" "video" "to-process" "journal")
        org-roam-graph-viewer "/usr/bin/firefox")
  :config
  (org-roam-mode +1)
  (require 'org-roam-protocol)
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam-capture--get-point)
           "\n\n- %?"
           :file-name "${slug}"
           :head "#+title: ${title}
#+roam_key: ${slug}
#+roam_tags: \"note\"
- tags ::"
           :unnarrowed t)))
  (setq org-roam-capture-ref-templates
        '(("d" "default" plain (function org-roam-capture--get-point)
           "\n\n- %?"
           :file-name "${slug}"
           :head "#+title: ${title}
#+roam_key: ${ref}
#+roam_tags: \"to-process\"
- tags ::"
           :unnarrowed t))))

;; org-roam-protocol
(use-package! org-roam-protocol
  :after org-protocol)

;; Org-roam server
(use-package! org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-network-poll nil))

;; Org journal
(use-package! org-journal
  :after org
  :bind
  ("C-c n j" . org-journal-new-entry)
  ("C-c n t" . org-journal-today)
  :config
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "journal-%Y-%m-%d.org"
        org-journal-dir (concat org-pkm "2b/org")
        org-journal-carryover-items nil
        org-journal-date-format "%Y-%m-%d"))

;; Deft
(use-package! deft
  :config
  (setq deft-extensions '("txt" "tex" "md" "org")
        deft-directory org-pkm
        deft-recursive t))

;; lsp
(use-package! lsp-mode
  :commands (lsp))

(use-package! company-capf)

;; Complements `find-defintions' (which is `g d')
(define-key evil-normal-state-map (kbd "g f") 'lsp-ui-peek-find-references)

(use-package! lsp-ui
  :after lsp-mode)

(after! lsp-ui
  (define-key lsp-ui-peek-mode-map (kbd "j") 'lsp-ui-peek--select-next)
  (define-key lsp-ui-peek-mode-map (kbd "k") 'lsp-ui-peek--select-prev)
  (define-key lsp-ui-peek-mode-map (kbd "C-k") 'lsp-ui-peek--select-prev-file)
  (define-key lsp-ui-peek-mode-map (kbd "C-j") 'lsp-ui-peek--select-next-file)

  (setq lsp-ui-peek-fontify 'always
        lsp-ui-peek-list-width 50
        lsp-ui-peek-peek-height 40

        lsp-ui-doc-enable t
        ;; Prevents LSP peek to disappear when mouse touches it
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-include-signature t
        lsp-ui-doc-delay 0.5
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-max-width 100
        lsp-ui-doc-max-height 40

        ;; This is just annoying, really
        lsp-ui-sideline-enable nil))

;; Languages
(use-package! groovy-mode
  :mode "\\.groovy\\'")
