;; your custom or vanilla emacs profile
(("vanilla" . ((user-emacs-directory . "~/.emacs-vanilla")
	       (server-name . "gnu")
	       ))

;; emacs distribution: DOOM-emacs
("doom" . ((user-emacs-directory . "~/doom-emacs")
	   (server-name . "doom")
	   (env . (("DOOMDIR" . "~/.doom.d")))
	     ))
  )
