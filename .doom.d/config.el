;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(load! "+bindings.el")
(load! "+org.el")
(setq org-directory "~/sync/org/")

;(setq doom-theme 'doom-gruvbox)
;(setq doom-theme 'doom-flatwhite)
(setq doom-theme 'doom-monokai-machine)
(setq doom-theme 'modus-operandi)

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :weight 'normal))

(setq display-line-numbers-type nil)
(pixel-scroll-mode)
(pixel-scroll-precision-mode)

;; ??????? can't run projectile file finding without it????
(setq browse-url-mosaic-program "firefox")

(setq user-full-name "Ben Lovell"
      user-mail-address "ben.j.lovell@gmail.com")

;; Trying helm again..
;; add recentf and bookmarks to switch buffers command
;(setq ivy-use-virtual-buffers t)
;(setq +ivy-project-search-engines '(rg ag))
;(setq counsel-projectile-sort-files t)
;(setq counsel-projectile-sort-buffers t)
;(setq neo-buffer-width 16)
;(setq neo-smart-open t)

(setq lsp-clojure-custom-server-command '("bash" "-c" "/run/current-system/sw/bin/clojure-lsp"))

(after! lsp-mode
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-auto-guess-root nil)
  (setq lsp-ui-sideline-show-code-actions nil))

(setq custom-safe-themes t)

(setq flyspell-lazy-idle-second 5)

;(use-package! catppuccin-theme
; :config
; (setq catppuccin-height-title1 1.5))

(after! ivy
;; add recentf and bookmarks to switch buffers command
  (setq ivy-use-virtual-buffers t
        ivy-count-format ""))

;(after! 'emojify (setq emojify-emoji-set "twemoji-v2-22"))

;(defun +personal-org-use-packages ()
;    (use-package! org-super-agenda
;      :after org-agenda
;      :init nil)
;
;  (use-package! org-alert
;    :ensure t
;                                        ;:defer 20
;    :config
;    (setq org-alert-interval 600)
;    (org-alert-enable)))
;
;(add-hook 'org-mode-hook #'+personal-org-use-packages)

;(add-hook 'after-init-hook #'global-emojify-mode)
(add-hook 'clojure-mode-hook (lambda ()
                               (define-clojure-indent
                                 ;; re-frame
                                 (reg-cofx :defn)
                                 (reg-event-db :defn)
                                 (reg-event-fx :defn)
                                 (reg-fx :defn)
                                 (reg-sub :defn)
                                 (reg-event-domain :defn)
                                 (reg-block-event-fx :defn)
                                 (reg-event-domain-fx :defn))
                               (modify-syntax-entry ?/ "_" clojure-mode-syntax-table)
                               (modify-syntax-entry ?- "w" clojure-mode-syntax-table)
                               (modify-syntax-entry ?? "w" clojure-mode-syntax-table)))

(defun spacemacs/clj-find-var ()
  "Attempts to jump-to-definition of the symbol-at-point. If CIDER fails, or not available, falls back to dumb-jump"
  (interactive)
  (let ((var (cider-symbol-at-point)))
    (if (and (cider-connected-p) (cider-var-info var))
        (unless (eq 'symbol (type-of (cider-find-var nil var)))
          (dumb-jump-go))
      (dumb-jump-go))))

;; stolen from spacemacs
;(defun ben/sudo-edit (&optional arg)
;  (interactive "P")
;  (let ((fname (if (or arg (not buffer-file-name))
;                   (read-file-name "File: ")
;                 buffer-file-name)))
;    (find-file
;     (cond ((string-match-p "^/ssh:" fname)
;            (with-temp-buffer
;              (insert fname)
;              (search-backward ":")
;              (let ((last-match-end nil)
;                    (last-ssh-hostname nil))
;                (while (string-match "@\\\([^:|]+\\\)" fname last-match-end)
;                  (setq last-ssh-hostname (or (match-string 1 fname)
;                                              last-ssh-hostname))
;                  (setq last-match-end (match-end 0)))
;                (insert (format "|sudo:%s" (or last-ssh-hostname "localhost"))))
;              (buffer-string)))
;           (t (concat "/sudo:root@localhost:" fname))))))

(display-time-mode t)

(setq calendar-longitude 13.4334646
      calendar-latitude 52.4714836
      display-time-24hr-format t
      alert-default-style 'libnotify)

(setq sql-connection-alist
      '((local-pitch (sql-product 'postgres)
                     (sql-database (concat "postgresql://pitch_super@localhost:54320/pitch?options=--search_path%3d"
                                           (or (getenv "PITCH_STAGE") "local-dev"))))))

(defalias 'eshell/vi #'eshell/emacs)
(defalias 'eshell/vim #'eshell/emacs)

; This stopped working when using latest src build of emacs, so manually setting
; (it's weird because it's in the $PATH)
(setq-default with-editor-emacsclient-executable "emacsclient")

;; `get-next-tag' is extremely slow in magit, with many tags in pitch repo magit-status is unusable
;(remove-hook 'magit-status-headers-hook 'magit-insert-tags-header)
;  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
;  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
;



(use-package! aider
  :config
  ;(setq aider-args '("--model" "ollama/qwen2.5-coder"))
  (setq aider-args '("--sonnet" "--no-check-update"))
  (load (expand-file-name "secrets.el" doom-user-dir))
  (setenv "ANTHROPIC_API_KEY" anthropic-api-key)
  (setenv "OLLAMA_API_BASE" "http://127.0.0.1:11434"))

(use-package! codespaces
  :config (codespaces-setup)
  :bind ("C-c S" . #'codespaces-connect))

(setq vc-handled-backends '(Git))
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(setq tramp-ssh-controlmaster-options "")


(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$" "" (shell-command-to-string
                                          "$SHELL --login -c 'echo $PATH'"
                                                    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

(after! tree-sitter
  (add-to-list 'treesit-language-source-alist
               '(typst "https://github.com/uben0/tree-sitter-typst")))

