;; org mode
;(use-package! org-fancy-priorities
;  :hook (org-mode . org-fancy-priorities-mode)
;  :config (setq org-fancy-priorities-list '("◓" "◓" "◓" "◓")))


;; custom width encoding -- let's leave it aside for now
;(defun my-org-faces ()
; ;'bens-org
;  (face-remap-add-relative 'org-default :inherit :default :height 1.0 :family "EtBembo")
;  (face-remap-add-relative 'org-todo :inherit 'fixed-pitch :height 1.0)
;  (face-remap-add-relative 'org-headline-done :foreground "#4C566A" :strike-through t :slant 'italic :family "EtBembo")
;  (face-remap-add-relative 'org-level-1 :inherit 'default :height 1.8 :family "EtBembo")
;  (face-remap-add-relative 'org-level-2 :inherit 'default :slant 'italic :height 1.6 :family "EtBembo")
;  (face-remap-add-relative 'org-level-3 :inherit 'default :height 1.4 :family "EtBembo")
;  (face-remap-add-relative 'org-level-4 :inherit 'default :height 1.2 :family "EtBembo")
;  (face-remap-add-relative 'org-level-5 :inherit 'default :height 1.2 :family "EtBembo")
;  (face-remap-add-relative 'org-level-6 :inherit 'default :height 1.2 :family "EtBembo")
;  (face-remap-add-relative 'org-level-7 :inherit 'default :height 1.2 :family "EtBembo")
;  (face-remap-add-relative 'org-level-8 :inherit 'default :height 1.2 :family "EtBembo")
;  (face-remap-add-relative 'org-tag :foreground "#86C0D1" :weight 'bold :family "EtBembo")
;  (face-remap-add-relative 'org-indent :inherit '(org-hide fixed-pitch))
;  (face-remap-add-relative 'org-link :inherit 'default :foreground "steel blue" :slant 'italic :weight 'semi-bold :family "EtBembo")
;  (face-remap-add-relative 'org-quote :background "#373E4C" :slant 'italic :family "EtBembo")
;  (face-remap-add-relative 'org-document-title :foreground "light gray" :weight 'ultra-bold :height 1.4 :family "EtBembo")
;  (face-remap-add-relative 'org-document-info :slant 'italic :height 1.2 :family "EtBembo")
;  (face-remap-add-relative 'org-document-info-keyword :inherit 'shadow :height 0.8 :family "EtBembo")
;  (face-remap-add-relative 'org-date :foreground "#ECCC87" :inherit 'fixed-pitch))
;
;(add-hook! 'org-mode-hook #'my-org-faces)
;(my-org-faces)


(defun files--in (base files)
  (cl-loop for f in files collect (concat base f)))

(after! org
  (setq org-directory "~/sync/org/"
        org-agenda-files (files--in org-directory '("todo.org" "routine.org" "calendar/gcal.org"))
        org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "PROJ(p)" "STARTED(s!)" "|" "DONE(d!)" "CANCELLED(c)"))
        org-log-done 'time
        org-capture-templates '(("t" "Inbox todo" entry
                                 (file+headline +org-capture-todo-file "Refile these:")
                                 "** TODO %?" :prepend t :kill-buffer t)
                                ("j" "Journal" entry
                                 (file+headline +org-capture-notes-file "Inbox")
                                 "* %u %?\n%i\n%a" :prepend t :kill-buffer t)
                                ("n" "Personal notes" entry
                                 (file+headline +org-capture-notes-file "Inbox")
                                 "* %u %?\n%i\n%a" :prepend t :kill-buffer t))
        org-agenda-skip-scheduled-if-done t
        org-ellipsis ""
        ;org-hide-emphasis-markers t
        org-hide-emphasis-markers nil
        org-agenda-time-grid '((daily today remove-match)
                              (800 1000 1200 1400 1600 1800 2000)
                              "......" "----------------")
        ;org-agenda-block-separator :"
        org-fontify-whole-heading-line t
        org-fontify-done-headline t
        line-space 0.2
        org-fast-tag-selection-single-key t
        ;; Don't right align tags, because it doesn't work with a proportioal font
        org-tags-column 0
        org-priority-faces '((?A :foreground "#E44955" :height 1.4)
                             (?B :foreground "#fcb37b" :height 1.4)
                             (?C :foreground "#fcf7b0" :height 1.4)
                             (?D :foreground "white" :height 1.4))
        org-bullets-bullet-list '("➔" "⇨"); '("◑" "◐") ;'(" ")
        org-gcal-file-alist '(("ben.j.lovell@gmail.com" . "~/sync/org/calendar/gcal.org")))

  ;(setq global-hl-line-mode nil)
  (setq hl-line-mode nil)
  ;(set-face-attribute 'hl-line nil)
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup)
  )
(after! evil-org
        (map! :map evil-org-mode-map
              :i [M-return] #'+org/insert-item-below
              :vn "o" #'+org/insert-item-below
              :localleader
              ")" #'org-tags-sparse-tree))

(use-package! org-gcal
 ; :bind (:map org-agenda-mode-map
 ;         ;; "r" is bound to org-agenda-redo
 ;         ("g" . org-gcal-fetch))
 ; :init
 ; (add-hook 'emacs-startup-hook #'org-gcal-fetch)
  )

(defun fetch-cal ()
  (interactive)
  ;; TODO find alternative to pass because it sucks balls die-gpg-die
  (setq org-gcal-client-id (+pass-get-secret "APIs/gcal-client-id")
        org-gcal-client-secret (+pass-get-secret "APIs/gcal-client-secret"))
  (org-gcal-fetch))

(defun my-org-agenda-recent-open-loops ()
  (interactive)
  (let ((org-agenda-start-with-log-mode t)
        (org-agenda-use-time-grid nil)
        (org-agenda-files '("~/sync/org/calendar/gcal.org" "~/sync/org/todos.org")))
    (fetch-cal)
    (org-agenda-list nil (org-read-date nil nil "-1d") 4)
                                        ;(beginend-org-agenda-mode-goto-beginning)
    ))

;; (defun my-org-agenda-longer-open-loops ()
;;   (interactive)
;;   (let ((org-agenda-start-with-log-mode t)
;;         (org-agenda-use-time-grid nil)
;;         (org-agenda-files '("~/org/calendar/gcal.org" "~/org/calendar/maple.org")))
;;     ;(fetch-calendar)
;;     (org-agenda-list 'file (org-read-date nil nil "-14d") 28)
;;     (beginend-org-agenda-mode-goto-beginning)))
