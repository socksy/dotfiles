;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(load! "+bindings.el")
(load! "+org.el")
(setq org-directory "~/sync/org/")

(setq my-fav-themes '(modus-operandi-tinted
                      doom-monokai-machine
                      doom-gruvbox
                      doom-flatwhite
                      doom-monokai-ristretto
                      doom-solarized-light
                      doom-oceanic-next
                      tsdh-dark))

(defun rand-nth (list) (nth (random (length list)) list))

(setq doom-theme (rand-nth my-fav-themes))


(setq font-families '("FiraCode Nerd Font"
                      "CaskaydiaCove Nerd Font"
                      "ZedMono Nerd Font"
                      "RobotoMono Nerd Font"
                      "RecMonoCasual Nerd Font"
                      "RecMonoDuotone Nerd Font"
                      "RecMonoLinear Nerd Font"))


;;(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :weight 'normal))
(setq doom-font (font-spec :family (rand-nth font-families) :size 16 :weight 'normal))

(setq display-line-numbers-type nil)
(pixel-scroll-mode)
(pixel-scroll-precision-mode)

;; ??????? can't run projectile file finding without it????
(setq browse-url-mosaic-program "firefox")

(setq user-full-name "Ben Lovell"
      user-mail-address "ben.j.lovell@gmail.com")

;; Trying helm again..
;; add recentf and bookmarks to switch buffers command
;;(setq ivy-use-virtual-buffers t)
;;(setq +ivy-project-search-engines '(rg ag))
;;(setq counsel-projectile-sort-files t)
;;(setq counsel-projectile-sort-buffers t)
;;(setq neo-buffer-width 16)
;;(setq neo-smart-open t)

(setq lsp-clojure-custom-server-command '("bash" "-c" "/run/current-system/sw/bin/clojure-lsp"))

(after! lsp-mode
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-auto-guess-root nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  )

(setq custom-safe-themes t)

(setq flyspell-lazy-idle-second 5)

;;(use-package! catppuccin-theme
;; :config
;; (setq catppuccin-height-title1 1.5))

(after! ivy
  ;; add recentf and bookmarks to switch buffers command
  (setq ivy-use-virtual-buffers t
        ivy-count-format ""))

;;(after! 'emojify (setq emojify-emoji-set "twemoji-v2-22"))

;;(defun +personal-org-use-packages ()
;;    (use-package! org-super-agenda
;;      :after org-agenda
;;      :init nil)
;;
;;  (use-package! org-alert
;;    :ensure t
;;                                        ;:defer 20
;;    :config
;;    (setq org-alert-interval 600)
;;    (org-alert-enable)))
;;
;;(add-hook 'org-mode-hook #'+personal-org-use-packages)

;;(add-hook 'after-init-hook #'global-emojify-mode)
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
;;(defun ben/sudo-edit (&optional arg)
;;  (interactive "P")
;;  (let ((fname (if (or arg (not buffer-file-name))
;;                   (read-file-name "File: ")
;;                 buffer-file-name)))
;;    (find-file
;;     (cond ((string-match-p "^/ssh:" fname)
;;            (with-temp-buffer
;;              (insert fname)
;;              (search-backward ":")
;;              (let ((last-match-end nil)
;;                    (last-ssh-hostname nil))
;;                (while (string-match "@\\\([^:|]+\\\)" fname last-match-end)
;;                  (setq last-ssh-hostname (or (match-string 1 fname)
;;                                              last-ssh-hostname))
;;                  (setq last-match-end (match-end 0)))
;;                (insert (format "|sudo:%s" (or last-ssh-hostname "localhost"))))
;;              (buffer-string)))
;;           (t (concat "/sudo:root@localhost:" fname))))))

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

;; This stopped working when using latest src build of emacs, so manually setting
;; (it's weird because it's in the $PATH)
(setq-default with-editor-emacsclient-executable "emacsclient")

;; `get-next-tag' is extremely slow in magit, with many tags in pitch repo magit-status is unusable
;;(remove-hook 'magit-status-headers-hook 'magit-insert-tags-header)
;;  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
;;  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
;;



;;(use-package! aider
;;  :config
;;(setq aider-args '("--model" "ollama/qwen2.5-coder"))
;;  (setq aider-args '("--sonnet" "--no-check-update"))
;;  (load (expand-file-name "secrets.el" doom-user-dir))
;;  (setenv "ANTHROPIC_API_KEY" anthropic-api-key)
;;  (setenv "OLLAMA_API_BASE" "http://127.0.0.1:11434"))

(use-package! codespaces
  :config (codespaces-setup)
  :bind ("C-c S" . #'codespaces-connect))

(use-package! claude-code-ide
  :config (claude-code-ide-emacs-tools-setup))

(use-package! vterm-anti-flicker-filter)

;; Fix emoji variants that cause line height issues in vterm
(set-fontset-font t '(#x2700 . #x27BF) (font-spec :family (face-attribute 'default :family))) ; Dingbats (includes ✳)
(set-fontset-font t '(#x23E9 . #x23FA) (font-spec :family (face-attribute 'default :family))) ; Media symbols (includes ⏺)

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

(defun +fold/auto-fold-go-errors ()
  "Automatically fold Go error checking blocks."
  (interactive)
  (when (and (eq major-mode 'go-mode)
             (+fold--ensure-hideshow-mode))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "err != nil {" nil t)
        (save-excursion
          (beginning-of-line)
          (when (+fold--hideshow-fold-p)
            (ignore-errors (+fold/close))))))))

(add-hook 'go-mode-hook
          (lambda ()
            (run-with-idle-timer 0.5 nil #'+fold/auto-fold-go-errors)))

;;(map! :map go-mode-map
;;      :localleader
;;      "f" #'+fold/auto-fold-go-errors)

(if (eq system-type 'darwin)
    (setq magit-git-executable "/run/current-system/sw/bin/git"))

(defun go-test--find-test ()
  "Find the current Go test function name."
  (save-excursion
    (when (re-search-backward "^func \\(Test[A-Za-z0-9_]+\\)" nil t)
      (match-string 1))))

(defun go-test--find-subtest (test-func)
  "Find the nearest t.Run subtest within TEST-FUNC."
  (save-excursion
    (when-let* ((current-pos (point))
                (func-start (when (re-search-backward (format "^func %s" (regexp-quote test-func)) nil t)
                              (point))))
      (goto-char current-pos)
      (when (re-search-backward "t\\.Run(\"\\([^\"]+\\)\"" func-start t)
        (replace-regexp-in-string " " "_" (match-string 1))))))

(defun go-test--add-subtest (test-func)
  (if-let ((subtest (go-test--find-subtest test-func)))
      (format "%s/%s" test-func subtest)
    test-func))


(defun go-test--build-command (test-name)
  (let* ((project-root (project-root (project-current)))
         (pkg-path (string-trim (file-relative-name default-directory project-root) "/")))
    (list (format "scripts/test.sh ./%s %s" pkg-path test-name) test-name project-root)))

(defun go-test--run-process (cmd-info)
  (let* ((cmd (nth 0 cmd-info))
         (test-name (nth 1 cmd-info))
         (project-root (nth 2 cmd-info))
         (default-directory project-root)
         (buffer (get-buffer-create (format "*go-test: %s*" test-name)))
         (process (progn
                    (with-current-buffer buffer
                      (let ((inhibit-read-only t)) (erase-buffer))
                      (insert (format "Running: %s\nFrom: %s\n\n" cmd project-root))
                      (ansi-color-for-comint-mode-on)
                      (evil-escape)
                      (comint-mode))
                    (start-process "go-test" buffer "bash" "-c" cmd))))
    (set-process-filter process 'comint-output-filter)
    (evil-escape)
    (display-buffer buffer)))

(defun run-go-test-at-point ()
  "Run the Go test script for the current test function and subtest."
  (interactive)
  (if-let ((test-func (go-test--find-test)))
      (->> test-func
           (go-test--add-subtest)
           (go-test--build-command)
           (go-test--run-process))
    (user-error "No test function found at point")))


(defun toggle-line-numbers ()
  "Toggle line numbers between normal (absolute) and disabled."
  (interactive)
  (if display-line-numbers
      (progn
        (display-line-numbers-mode -1)
        (message "Line numbers disabled"))
    (progn
      (display-line-numbers-mode 1)
      (setq display-line-numbers t)
      (message "Line numbers enabled"))))
