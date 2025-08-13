;;; -*- lexical-binding: t; -*-
;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

                                        ;(package! org-fancy-priorities)
                                        ;(package! org-super-agenda)
;;(package! emojify)
                                        ;(package! org-alert)
                                        ;(package! helm-spotify-plus)
(package! git-link)
(package! jarchive)

                                        ;(package! org-superstar)
                                        ;(package! feature-mode)
                                        ;
                                        ;(package! catppuccin-theme)
                                        ;(package! elpher)

                                        ;(package! emacs-conflict :recipe (:host github :repo "ibizaman/emacs-conflicts"
                                        ;                                        :files ("emacs-conflict.el")))
                                        ;
                                        ;(package! emacs-conflict
                                        ;  :straight (emacs-conflict :type git :host github :repo "ibizaman/emacs-conflict" :branch "master"))


;; All of Doom's packages are pinned to a specific commit, and updated from
;; release to release. To un-pin all packages and live on the edge, do:
                                        ;(unpin! t)

;; ...but to unpin a single package:
                                        ;(unpin! pinned-package)
;; Use it to unpin multiple packages
                                        ;(unpin! pinned-package another-pinned-package)


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a particular repo, you'll need to specify
;; a `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, for whatever reason,
;; you can do so here with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

(package! feature-mode)

;(package! aider :recipe (:host github :repo "tninja/aider.el" :files ("*.el")))

;; Typst
(package! typst-ts-mode
  :recipe (:type git :host codeberg :repo "meow_king/typst-ts-mode"
           :files (:defaults "*.el")))

(package! codespaces
  :recipe (:host github 
           :repo "patrickt/codespaces.el" 
           :files (:defaults "*.el")))

(package! protobuf-mode
  :recipe (:host github :repo "protocolbuffers/protobuf"
           :files ("editors/protobuf-mode.el")))

(package! claude-code-ide
  :recipe (:host github :repo "manzaltu/claude-code-ide.el"))

(package! vterm-anti-flicker-filter
  :recipe (:host github :repo "martinbaillie/vterm-anti-flicker-filter"))
