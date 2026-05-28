;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Mike Vanbuskirk"
      user-mail-address "mike@mikevanbuskirk.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Hack Nerd Font" )
      doom-big-font (font-spec :family "Hack Nerd Font Mono" :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-agenda-files '("~/org/inbox.org"
                         "~/org/todo.org"
                         "~/org/journal.org"
                         "~/org/notes.org"
                         "~/org/code_todo.org"
                         "~/org/reviews.org"))
;; Show unscheduled TODO items in agenda
(setq org-agenda-include-deadlines t)
(setq org-agenda-include-diary nil)
(setq org-agenda-todo-ignore-scheduled nil)
(setq org-agenda-todo-ignore-deadlines nil)
(setq org-agenda-todo-ignore-with-date nil)

;; Custom agenda view that includes unscheduled TODOs
(setq org-agenda-custom-commands
      '(("d" "Daily agenda and all TODOs"
         ((agenda "" ((org-agenda-span 1)))
          (alltodo "" ((org-agenda-overriding-header "All TODOs:")))))
        ("w" "Weekly agenda and all TODOs"
         ((agenda "" ((org-agenda-span 7)))
          (alltodo "" ((org-agenda-overriding-header "All TODOs:")))))))


;; General config
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
(setq shell-file-name "/bin/zsh")

;; mac meta key hack
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier 'meta)

(global-auto-revert-mode t)
;; Set default transparency mode
(add-to-list 'default-frame-alist '(alpha . 95))

(use-package! autothemer
  :ensure t)

(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)
(setq doom-themes-treemacs-theme "doom-colors")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loadedh
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(when (daemonp)
  (exec-path-from-shell-initialize))

;; Bound native-comp worker concurrency so a daemon crash can't orphan dozens
;; of stuck batch subprocesses.
(setq native-comp-async-jobs-number 2)

;; Drain the comp queue and signal any in-flight async compile workers before
;; emacs exits, so they don't survive as PPID-1 zombies.
(add-hook 'kill-emacs-hook
          (lambda ()
            (when (boundp 'comp-files-queue)
              (setq comp-files-queue nil))
            (dolist (proc (process-list))
              (when (and (process-live-p proc)
                         (string-match-p "async-native-compile\\|comp-async"
                                         (process-name proc)))
                (ignore-errors (kill-process proc))))))

(use-package! websocket
    :after org)

;; python lsp
(after! eglot
  (add-to-list 'eglot-server-programs
               '(python-mode . ("ty" "server"))))
