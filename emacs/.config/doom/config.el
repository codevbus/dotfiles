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
(setq org-local "~/Documents/org/")
(setq org-pkm "~/Dropbox/beorg/org/")
(setq org-projects "~/Dropbox/org/")
(setq org-agenda-files (list org-local (concat org-projects "freelance/")
                       (concat org-pkm "inbox.org")
                       (concat org-pkm "contentsprocket.org")
                       (concat org-projects "projects.org")))
(setq org-refile-targets '((nil :maxlevel . 9)
      (org-agenda-files :maxlevel . 9)))


;; General config
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
;; Set shell based on operating system
(setq shell-file-name
      (cond
       ((eq system-type 'darwin)     "/bin/zsh")        ; macOS
       ((eq system-type 'gnu/linux)  "/usr/bin/zsh")    ; Linux
       (t "/bin/sh")))                                   ; fallback for other systems
;(setq shell-file-name "/bin/zsh")

(global-auto-revert-mode t)
;; Set default transparency mode
(add-to-list 'default-frame-alist '(alpha . 85))

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

;; Python
(add-hook! 'python-base-mode-hook 'pet-mode)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-base-mode :language-id "python") . ("ty" "server"))))

(add-hook 'python-base-mode-hook 'eglot-ensure)

;; ty handles type checking; ruff handles lint diagnostics. eglot resets
;; `flymake-diagnostic-functions' to its own backend, so add ruff back
;; *after* eglot takes over the buffer.
(after! flymake-ruff
  (add-hook 'eglot-managed-mode-hook #'flymake-ruff-load))

(after! flycheck
  (add-to-list 'flycheck-disabled-checkers 'python-mypy)
  (add-to-list 'flycheck-disabled-checkers 'python-pylint)
  (add-to-list 'flycheck-disabled-checkers 'python-pyright)
  (add-to-list 'flycheck-disabled-checkers 'python-flake8))

;; Format on save with ruff (import sort + format), replacing black/isort.
(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff)
        (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff)))

;; disable mypy
(add-hook! 'python-base-mode-hook :append
  (defun +py/trim-flycheck-checkers ()
    (make-local-variable 'flycheck-disabled-checkers)
    (dolist (c '(python-mypy python-pyright python-pycompile))
      (cl-pushnew c flycheck-disabled-checkers))))

;; Manual targeted ruff fix: sort imports + drop unused (I, F401) on the
;; current file only. Uses the venv's ruff resolved via pet's exec-path.
(defun my/ruff-fix-imports ()
  "Sort and prune imports in the current file with ruff."
  (interactive)
  (when buffer-file-name
    (save-buffer)
    (let ((ruff (or (executable-find "ruff") "ruff")))
      (call-process ruff nil nil nil
                    "check" "--select" "I,F401" "--fix" buffer-file-name))
    (revert-buffer t t t)))
(map! :after python
      :localleader :map python-base-mode-map
      "i" #'my/ruff-fix-imports)
;;; Org roam
(after! org
  (setq org-roam-directory (concat org-pkm "2b/org"))); they are implemented.

(after! org-roam2
  :ensure t
  :init
  (setq org-roam-capture-templates
        '(
          ("d" "default" plain
           "\n\n- %?"
           :target (file+head "${slug}.org" "#+TITLE: ${title}\n")
           :unnarrowed t))))

(use-package! websocket
    :after org)

(use-package! org-roam-ui
    :after org ;; or :after o
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t))

(defun my/find-nobacklink-daily-notes()
  "Find daily notes with zero connections."
  (interactive)
  (let ((results (org-roam-db-query
                   [:select [nodes:file nodes:title
                            (as [:select (funcall count links:source)
                                 :from links
                                 :where (and (= links:source nodes:id)
                                            (= links:type "id"))] outgoing)
                            (as [:select (funcall count links:dest)
                                 :from links
                                 :where (and (= links:dest nodes:id)
                                            (= links:type "id"))] incoming)]
                    :from nodes
                    :where (like nodes:file "%/daily/%")])))
    (with-current-buffer (get-buffer-create "*Isolated Daily Notes*")
      (erase-buffer)
      (insert "Truly isolated daily notes (0 in, 0 out):\n\n")
      (let ((isolated-count 0))
        (dolist (result results)
          (let ((file (nth 0 result))
                (title (nth 1 result))
                (outgoing (nth 2 result))
                (incoming (nth 3 result)))
            (when (and (= outgoing 0) (= incoming 0))
              (insert-button (file-name-nondirectory file)
                            'action (lambda (_) (find-file file))
                            'follow-link t
                            'help-echo file)
              (insert (format " - %s\n" title))
              (setq isolated-count (1+ isolated-count)))))
        (goto-char (point-min))
        (forward-line 2)
        (insert (format "Found %d isolated daily notes\n\n" isolated-count)))
      (pop-to-buffer (current-buffer)))))

(defun my/find-duplicate-titles-or-aliases (search-term)
  "Find all files with the same title or alias."
  (interactive "sSearch for duplicate title/alias: ")
  (let ((title-matches (org-roam-db-query
                        [:select [nodes:file nodes:title]
                         :from nodes
                         :where (= nodes:title $s1)]
                        search-term))
        (alias-matches (org-roam-db-query
                        [:select [nodes:file aliases:alias]
                         :from [nodes aliases]
                         :where (and (= nodes:id aliases:node-id)
                                    (= aliases:alias $s1))]
                        search-term)))
    (with-current-buffer (get-buffer-create "*Duplicate Analysis*")
      (erase-buffer)
      (insert (format "Files with title '%s':\n" search-term))
      (dolist (match title-matches)
        (insert-button (file-name-nondirectory (car match))
                      'action (lambda (_) (find-file (car match)))
                      'follow-link t
                      'help-echo (car match))
        (insert (format " - %s\n" (cadr match))))
      (insert (format "\nFiles with alias '%s':\n" search-term))
      (dolist (match alias-matches)
        (insert-button (file-name-nondirectory (car match))
                      'action (lambda (_) (find-file (car match)))
                      'follow-link t
                      'help-echo (car match))
        (insert (format " - %s\n" (cadr match))))
      (pop-to-buffer (current-buffer)))))
