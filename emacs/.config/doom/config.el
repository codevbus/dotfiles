;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Load machine-local settings (org paths, homelab hosts) from gitignored
;; local.el. Copy local.el.example to local.el on a new machine.
(load! "local" nil t)


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

                                        ; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; Fallbacks; real paths set in local.el. defvar won't clobber that.
(defvar org-local    "~/org/"           "Local org directory.")
(defvar org-pkm      "~/org/pkm/"       "PKM/notes org root.")
(defvar org-projects "~/org/projects/"  "Project org root.")
(setq org-agenda-files (list org-local (concat org-projects "freelance/")
                             (concat org-pkm "inbox.org")
                             (concat org-pkm "next.org")
                             (concat org-pkm "someday.org")
                             (concat org-projects "projects.org")))
;; org-refile-targets configured below in `after! org' block

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
;; Background transparency. `alpha' sets the X _NET_WM_WINDOW_OPACITY property,
;; which picom honored but Hyprland/Wayland does NOT for XWayland clients -- so it
;; silently does nothing. `alpha-background' (Emacs 29+) uses a real ARGB visual
;; (compositor-agnostic) and only dims the background, keeping text opaque.
(add-to-list 'default-frame-alist '(alpha-background . 85))

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

;;; TRAMP
(after! tramp
  (setq tramp-default-method "ssh"
        tramp-verbose 1))

;; TRAMP host bookmarks for my/homelab-connect; real table set in local.el.
(defvar my/homelab-hosts nil
  "Alist of (LABEL . TRAMP-PATH) homelab bookmarks.")

(defun my/homelab-connect ()
  "Quick-connect to a homelab host via TRAMP."
  (interactive)
  (let* ((selection (completing-read "Host: " (mapcar #'car my/homelab-hosts) nil t))
         (path (cdr (assoc selection my/homelab-hosts))))
    (find-file path)))

(defun my/homelab-find-file ()
  "Find file on a homelab host via TRAMP."
  (interactive)
  (let* ((selection (completing-read "Host: " (mapcar #'car my/homelab-hosts) nil t))
         (path (cdr (assoc selection my/homelab-hosts))))
    (let ((default-directory path))
      (call-interactively #'find-file))))

;;; Performance tuning
(setq read-process-output-max (* 1024 1024)) ; 1MB for LSP subprocess communication
(setq gcmh-high-cons-threshold (* 64 1024 1024)) ; 64MB during active use

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

(after! company
  (setq company-idle-delay 0.3
        company-minimum-prefix-length 2))

;;; Projectile / Workspace (sessionizer replacement)
(setq projectile-project-search-path `(("~/projects" . 1)
                                       (,org-local . 0)
                                       (,org-pkm . 1)
                                       ("~/dotfiles" . 0)))
;; Disable auto workspace creation — sessionizer is the single entry point
(setq +workspaces-on-switch-project-behavior nil)
;; Use fd for indexing — faster, respects .gitignore, always fresh (no caching needed)
(setq projectile-indexing-method 'alien
      projectile-generic-command "fd . -0 --type f --color=never"
      projectile-enable-caching nil
      ;; Fall back to default-directory when not in a project (avoids nil errors)
      projectile-require-project-root nil
      ;; Don't try projectile commands over TRAMP (slow and breaks context)
      projectile-mode-line '(:eval (if (file-remote-p default-directory) "" (projectile-project-name))))

(after! projectile
  ;; Skip Syncthing/system marker dirs during project discovery
  (dolist (dir '(".stfolder" ".stversions" ".sync"))
    (add-to-list 'projectile-globally-ignored-directories dir))
  ;; Auto-discover projects on startup so the list is pre-loaded
  (projectile-discover-projects-in-search-path))

;; Terminal opener for a fresh session's pane. Per-machine swap: `+vterm/here'
;; on Linux (vterm), `ghostel' on the Mac ghostty/ghostel setup. Set to nil to
;; skip the terminal pane entirely.
(defvar my/sessionizer-terminal-fn #'+vterm/here
  "Function (called with no args) that opens a terminal in the current
window, rooted at `default-directory'.")

(defvar my/sessionizer-terminal-height 0.35
  "Fraction of the frame height given to the sessionizer terminal pane.")

(defun my/sessionizer--setup-layout (dir)
  "Give a fresh workspace a dired-over-terminal layout, both rooted at DIR."
  (let ((default-directory (file-name-as-directory dir)))
    (delete-other-windows)
    (dired dir)
    (when (functionp my/sessionizer-terminal-fn)
      (let ((split-window-keep-point t))
        (split-window-below (- (round (* my/sessionizer-terminal-height
                                         (window-total-height))))))
      (other-window 1)
      (funcall my/sessionizer-terminal-fn))))

(defun my/sessionizer ()
  "Switch to a project in its own workspace (like tmux sessionizer).
Projects are discovered via projectile; a fresh workspace opens dired over
a terminal. Re-entering an existing workspace switches to it without
rebuilding panes. Single entry point for project switching."
  (interactive)
  (let* ((projects (projectile-relevant-known-projects))
         (name-to-path (make-hash-table :test 'equal)))
    ;; Build lookup — append parent dir for duplicates
    (dolist (p projects)
      (let ((name (file-name-nondirectory (directory-file-name p))))
        (when (gethash name name-to-path)
          (let ((existing (gethash name name-to-path)))
            (remhash name name-to-path)
            (puthash (format "%s [%s]" (file-name-nondirectory (directory-file-name existing))
                             (file-name-nondirectory (directory-file-name (file-name-directory (directory-file-name existing)))))
                     existing name-to-path)
            (setq name (format "%s [%s]" name
                               (file-name-nondirectory (directory-file-name (file-name-directory (directory-file-name p))))))))
        (puthash name p name-to-path)))
    (let* ((selection (completing-read "Session: " (hash-table-keys name-to-path) nil t))
           (project-path (gethash selection name-to-path))
           (existed (member selection (+workspace-list-names))))
      ;; Switch to (or create) the workspace, then tag it with its project
      ;; root via the persp parameter Doom itself reads
      ;; (`+workspaces-switch-to-project-h', ws-param `+workspace-project'), so
      ;; SPC p p / find-file resolve the root with no custom table or advice on
      ;; the hot `projectile-project-root'.
      (+workspace-switch selection t)
      (set-persp-parameter '+workspace-project
                           (file-truename project-path)
                           (+workspace-get selection))
      (unless existed
        (my/sessionizer--setup-layout project-path)))))

;;; Terminal (multi-vterm)
(use-package! multi-vterm
  :config
  (setq multi-vterm-dedicated-window-height-percent 30))

(after! vterm
  (setq vterm-max-scrollback 10000
        vterm-timer-delay 0.01)
  ;; Let window nav keys escape to Emacs instead of being sent to terminal
  (dolist (key '("C-h" "C-j" "C-k" "C-l"))
    (add-to-list 'vterm-keymap-exceptions key))
  ;; Also bind directly in vterm-mode-map to override any buffer-local bindings
  (define-key vterm-mode-map (kbd "C-h") #'evil-window-left)
  (define-key vterm-mode-map (kbd "C-j") #'evil-window-down)
  (define-key vterm-mode-map (kbd "C-k") #'evil-window-up)
  (define-key vterm-mode-map (kbd "C-l") #'evil-window-right))

;; ensure GIT_EDITOR is explicitly
;; (picom/glx window bug?)
(setenv "GIT_EDITOR" "emacsclient -c -a ''")

;;; Keybindings
(setq which-key-idle-delay 0.3)

;; Use consult-fd instead of locate for SPC s f
(setq consult-locate-args "fd --color=never")

;; Window navigation with C-h/j/k/l (no prefix needed, vim-tmux-navigator style)
;; Move help from C-h to M-? — SPC h is still available via leader
(global-set-key (kbd "M-?") help-map)
(map! :map 'override
      "C-h" #'evil-window-left
      "C-j" #'evil-window-down
      "C-k" #'evil-window-up
      "C-l" #'evil-window-right)

(map! :leader
      ;; Sessionizer
      :desc "Sessionizer" "p w" #'my/sessionizer

      ;; Buffer/file quick access
      :desc "Switch buffer (workspace)" "," #'persp-switch-to-buffer
      :desc "Find file in project"      "." #'projectile-find-file

      ;; Insert (extends Doom's SPC i menu)
      (:prefix "i"
       :desc "Yank as src block" "S" #'my/yank-as-src-block)

      ;; Homelab TRAMP
      (:prefix ("r" . "remote")
       :desc "Connect to host"    "c" #'my/homelab-connect
       :desc "Find file on host"  "f" #'my/homelab-find-file)

      ;; vterm prefix
      (:prefix ("v" . "vterm")
       :desc "Toggle vterm popup"    "t" #'+vterm/toggle
       :desc "New vterm"             "n" #'multi-vterm
       :desc "Next vterm"            "l" #'multi-vterm-next
       :desc "Prev vterm"            "h" #'multi-vterm-prev
       :desc "Dedicated vterm"       "d" #'multi-vterm-dedicated-toggle
       :desc "Project vterm"         "p" #'multi-vterm-project))

;;; Format on save — only for specific modes
(setq +format-on-save-enabled-modes '(python-mode go-mode nix-mode terraform-mode))

;;; Insert helpers
(defun my/yank-as-src-block (lang)
  "Insert the latest kill at point, wrapped in an Org #+begin_src LANG block.
Buffer-agnostic — just inserts text, so it works anywhere, not only Org."
  (interactive (list (read-string "src language: " "emacs-lisp")))
  (let ((text (string-trim-right (substring-no-properties (current-kill 0)))))
    (insert (format "#+begin_src %s\n%s\n#+end_src\n" lang text))))

;;; Org roam
(after! org
  (setq org-roam-directory (concat org-pkm "2b/org"))

  ;; Keep pasted code's own indentation in src blocks — no org offset/reindent
  (setq org-src-preserve-indentation t
        org-edit-src-content-indentation 0)

  ;; TODO keywords — Ugmonk-inspired statuses
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "DELEGATED(e)" "|" "DONE(d)" "CANCELLED(c)")))

  ;; Capture templates (beorg-compatible — files in Dropbox)
  (setq org-capture-templates
        `(("t" "Todo (Inbox)" entry (file+headline ,(concat org-pkm "inbox.org") "To-do")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i")
          ("n" "Next" entry (file+headline ,(concat org-pkm "next.org") "Tasks")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i")
          ("s" "Someday" entry (file+headline ,(concat org-pkm "someday.org") "Ideas")
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i")
          ("N" "Note" entry (file+headline ,(concat org-pkm "inbox.org") "Notes")
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i")
          ("l" "Link/Bookmark" entry (file+headline ,(concat org-pkm "inbox.org") "To-read/To-listen")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:URL: %^{URL}\n:END:\n%i")
          ("p" "Project" entry (file+headline ,(concat org-pkm "inbox.org") "Projects")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i")
          ("m" "Meeting Notes" entry (file+olp+datetree ,(concat org-pkm "meetings.org"))
           "* %? :meeting:\n:PROPERTIES:\n:ATTENDEES:\n:END:\n** Agenda\n** Notes\n** Action Items")))

  ;; Agenda custom views — Ugmonk dashboard
  (setq org-agenda-custom-commands
        `(("u" "Ugmonk Dashboard"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-overriding-header "Today")))
            (todo "TODO|IN-PROGRESS"
                  ((org-agenda-files (list ,(concat org-pkm "next.org")))
                   (org-agenda-overriding-header "Next — Pull from here to Today")))
            (todo "TODO"
                  ((org-agenda-files (list ,(concat org-pkm "someday.org")))
                   (org-agenda-overriding-header "Someday — Ideas & Aspirations")))))
          ("d" "Daily Overview" ((agenda "" ((org-agenda-span 'day)))
                                 (tags-todo "+PRIORITY=\"A\""
                                            ((org-agenda-overriding-header "High Priority")))
                                 (todo "TODO"
                                       ((org-agenda-overriding-header "All Tasks")))))
          ("i" "Inbox" tags-todo "+inbox"
           ((org-agenda-overriding-header "Inbox - Process These")))))

  ;; Refile — flat outline-path UI (vertico-friendly), creates parents on demand
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm
        org-refile-targets `((,(concat org-pkm "inbox.org") :maxlevel . 3)
                             (,(concat org-pkm "next.org") :maxlevel . 2)
                             (,(concat org-pkm "someday.org") :maxlevel . 2)
                             (,(concat org-projects "projects.org") :maxlevel . 3)
                             (org-agenda-files :maxlevel . 2))))

(after! org-roam
  (setq org-roam-capture-templates
        '(("d" "default" plain
           "\n\n- %?"
           :target (file+head "${slug}.org" "#+TITLE: ${title}\n")
           :unnarrowed t)
          ("w" "work" plain
           "\n\n- %?"
           :target (file+head "work/${slug}.org" "#+TITLE: ${title}\n#+FILETAGS: :work:\n")
           :unnarrowed t)
          ("p" "project" plain
           "\n\n- %?"
           :target (file+head "projects/${slug}.org" "#+TITLE: ${title}\n#+FILETAGS: :project:\n")
           :unnarrowed t)))

  ;; Daily notes (Ugmonk Today card — fresh each day)
  (setq org-roam-dailies-directory "daily/")

  (setq org-roam-dailies-capture-templates
        '(("d" "Daily Plan" entry
           "* TODO %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n\n* Today\n* Review\n** What got done?\n** What's moving to tomorrow?\n** PKM\n- [ ] Forward rule — literature notes today have a permanent note\n- [ ] Process inbox.org Notes/To-read\n- [ ] One touch on active structure note\n"))
          ("t" "Trading Journal" entry
           "* %?"
           :target (file+head "trading/%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d> Trading\n#+filetags: :trading:\n\n* Session Summary\n-\n** VIX\n- High:\n- Low:\n** ES\n** NQ\n* Trades\n")))))

(use-package! websocket
  :after org)

(use-package! org-roam-ui
  :after org ;; or :after o
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t))

(defun my/find-nobacklink-daily-notes()
  "Find daily notes with zero connections, excluding :trading: journals.
Trading journals are logs, not idea-notes — legitimately isolated, so they
are filtered out to keep this an extraction-candidate list.  (Mining journals
for generalizable setups/lessons is a separate, deliberate workflow.)"
  (interactive)
  (let* ((trading (mapcar #'car
                          (org-roam-db-query
                           [:select tags:node-id :from tags
                            :where (= tags:tag "trading")])))
         (results (org-roam-db-query
                   [:select [nodes:id nodes:file nodes:title
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
      (insert "Truly isolated daily notes (0 in, 0 out), excluding :trading: journals:\n\n")
      (let ((isolated-count 0))
        (dolist (result results)
          (let ((id (nth 0 result))
                (file (nth 1 result))
                (title (nth 2 result))
                (outgoing (nth 3 result))
                (incoming (nth 4 result)))
            (when (and (= outgoing 0) (= incoming 0)
                       (not (member id trading)))
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

(defun my/org-body-content-lines (file)
  "Count meaningful body lines in FILE.
Excludes drawers (:PROPERTIES:, :LOGBOOK:, …), #+keywords, # comments, and
blank lines.  A return of 0 means the file is pure scaffolding — a stub."
  (if (not (file-readable-p file))
      0
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (let ((count 0) (in-drawer nil))
        (while (not (eobp))
          (let ((line (string-trim
                       (buffer-substring-no-properties
                        (line-beginning-position) (line-end-position)))))
            (cond
             ;; a bare :WORD: line opens (or, for :END:, closes) a drawer
             ((string-match-p "\\`:[A-Za-z0-9_]+:\\'" line)
              (setq in-drawer (not (string-equal-ignore-case line ":END:"))))
             (in-drawer nil)                  ; inside a drawer — skip
             ((string-empty-p line) nil)      ; blank
             ((string-prefix-p "#" line) nil) ; #+keywords and # comments
             ((string-prefix-p ":" line) nil) ; stray drawer property lines
             (t (setq count (1+ count)))))
          (forward-line 1))
        count))))

(defun my/roam-link-kind (source-file dest-id)
  "How does SOURCE-FILE link to DEST-ID?
Return `real' if the id appears on any line that is not a legacy
`- tags ::' line, `tag' if it appears only on tags lines, else nil."
  (when (file-readable-p source-file)
    (with-temp-buffer
      (insert-file-contents source-file)
      (goto-char (point-min))
      (let ((needle (concat "[[id:" dest-id))
            (found nil) (real nil))
        (while (search-forward needle nil t)
          (setq found t)
          (let ((line (string-trim
                       (buffer-substring-no-properties
                        (line-beginning-position) (line-end-position)))))
            (unless (string-match-p "\\`-?[[:space:]]*tags[[:space:]]*::" line)
              (setq real t))))
        (cond (real 'real) (found 'tag) (t nil))))))

(defun my/find-stub-notes (&optional max-body-lines)
  "List stub notes (empty-bodied file-level nodes), classified by how — and
whether — anything really links to them.  Three buckets:

  ORPHAN     no inbound id-links at all                → safe to delete
  TAG-ONLY   linked only by legacy `- tags ::' lines   → promote or retire
  REFERENCED a real inline `[[id:]]' link wants it      → promote

With a prefix arg, count notes with up to that many body lines as stubs
\(default 0 = empty body only).  Body is read from disk; link sources come
from the db — run `org-roam-db-sync' first if you have unsynced edits.
Reads source files to classify each link, so it may take a moment."
  (interactive "P")
  (let* ((threshold (if max-body-lines (prefix-numeric-value max-body-lines) 0))
         (rows (org-roam-db-query
                [:select [nodes:id nodes:file nodes:title]
                 :from nodes :where (= nodes:level 0)]))
         (orphan nil) (tag-only nil) (referenced nil))
    (dolist (row rows)
      (let ((id (nth 0 row)) (file (nth 1 row)) (title (nth 2 row)))
        (when (and (not (string-match-p "/daily/" file))
                   (<= (my/org-body-content-lines file) threshold))
          (let ((srcs (delete-dups
                       (mapcar #'car
                               (org-roam-db-query
                                [:select nodes:file
                                 :from [links nodes]
                                 :where (and (= links:source nodes:id)
                                             (= links:dest $s1)
                                             (= links:type "id"))]
                                id))))
                (real 0) (tag 0))
            (dolist (s srcs)
              (pcase (my/roam-link-kind s id)
                ('real (setq real (1+ real)))
                ('tag  (setq tag  (1+ tag)))))
            (cond ((> real 0) (push (list file title real) referenced))
                  ((> tag 0)  (push (list file title tag)  tag-only))
                  (t          (push (list file title)      orphan)))))))
    (cl-flet ((bytitle (l) (sort l (lambda (a b) (string< (cadr a) (cadr b)))))
              (section (heading lst note countp)
                (insert (format "\n── %s (%d) ──\n%s" heading (length lst)
                                (if note (concat note "\n") "")))
                (dolist (e lst)
                  (let ((file (car e)) (title (cadr e)) (n (nth 2 e)))
                    (insert-button (file-name-nondirectory file)
                                   'action (lambda (_) (find-file file))
                                   'follow-link t 'help-echo file)
                    (insert (if (and countp n)
                                (format "  %s  [%d]\n" title n)
                              (format "  %s\n" title)))))))
      (setq orphan (bytitle orphan) tag-only (bytitle tag-only)
            referenced (bytitle referenced))
      (with-current-buffer (get-buffer-create "*PKM Stubs*")
        (erase-buffer)
        (insert (format "Stub notes (body ≤ %d content line%s)\n"
                        threshold (if (= threshold 1) "" "s")))
        (insert (format "%d orphan · %d tag-only · %d referenced\n"
                        (length orphan) (length tag-only) (length referenced)))
        (section "ORPHAN — no inbound links, safe to delete" orphan nil nil)
        (section "TAG-ONLY — linked only by legacy `tags ::', promote or retire"
                 tag-only "  [n] = how many tags-lines point here" t)
        (section "REFERENCED — a real inline link wants this, promote"
                 referenced "  [n] = inline references" t)
        (goto-char (point-min))
        (pop-to-buffer (current-buffer))))))

(defun my/find-tags-line-references (node)
  "List every legacy `- tags ::' line in other notes that references NODE.
Cleanup checklist for retiring a tag-only stub: visit each line, strip the
link (or delete the line), then delete the stub and `org-roam-db-sync'.
Buttons jump straight to the referencing line."
  (interactive (list (org-roam-node-read nil nil nil t)))
  (let* ((id (org-roam-node-id node))
         (title (org-roam-node-title node))
         (srcs (delete-dups
                (mapcar #'car
                        (org-roam-db-query
                         [:select nodes:file
                          :from [links nodes]
                          :where (and (= links:source nodes:id)
                                      (= links:dest $s1)
                                      (= links:type "id"))]
                         id))))
         (needle (concat "[[id:" id))
         (hits nil))                    ; (file line text)
    (dolist (file srcs)
      (when (file-readable-p file)
        (with-temp-buffer
          (insert-file-contents file)
          (goto-char (point-min))
          (while (search-forward needle nil t)
            (let ((line (string-trim
                         (buffer-substring-no-properties
                          (line-beginning-position) (line-end-position)))))
              (when (string-match-p "\\`-?[[:space:]]*tags[[:space:]]*::" line)
                (push (list file (line-number-at-pos) line) hits)))))))
    (setq hits (nreverse hits))
    (with-current-buffer (get-buffer-create "*Tags-line References*")
      (erase-buffer)
      (insert (format "tags :: references to: %s\n  id:%s\n\n" title id))
      (insert (format "%d tags-line%s across %d file%s\n\n"
                      (length hits) (if (= (length hits) 1) "" "s")
                      (length srcs) (if (= (length srcs) 1) "" "s")))
      (if (null hits)
          (insert "No tags-line references found — nothing to clean before delete.\n")
        (dolist (h hits)
          (let ((file (nth 0 h)) (ln (nth 1 h)) (text (nth 2 h)))
            (insert-button (format "%s:%d" (file-name-nondirectory file) ln)
                           'action (lambda (_)
                                     (find-file file)
                                     (goto-char (point-min))
                                     (forward-line (1- ln)))
                           'follow-link t 'help-echo file)
            (insert (format "\n    %s\n\n" text)))))
      (goto-char (point-min))
      (pop-to-buffer (current-buffer)))))

;;; LLM / gptel — :tools llm module handles bindings, popup rules, magit hookup.
;; Format authinfo entries as:
;;   machine api.anthropic.com login apikey password sk-ant-...
;;   machine integrate.api.nvidia.com login apikey password nvapi-...
(setq auth-sources '("~/.authinfo.gpg" "~/.authinfo"))

(after! gptel
  ;; Anthropic as default — prompt caching + tool use
  (setq gptel-backend
        (gptel-make-anthropic "Claude"
          :stream t
          :key (lambda () (auth-source-pick-first-password :host "api.anthropic.com"))))
  (setq gptel-model 'claude-opus-4-7)

  ;; NVIDIA NIM (OpenAI-compatible) — free open-weight models
  (gptel-make-openai "NVIDIA"
    :host "integrate.api.nvidia.com"
    :endpoint "/v1/chat/completions"
    :stream t
    :key (lambda () (auth-source-pick-first-password :host "integrate.api.nvidia.com"))
    :models '(meta/llama-3.3-70b-instruct
              deepseek-ai/deepseek-r1
              nvidia/llama-3.1-nemotron-70b-instruct
              qwen/qwen2.5-coder-32b-instruct)))

