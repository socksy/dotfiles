(deftheme bens-org
  "Created 2019-09-01.")

(custom-theme-set-variables
 'bens-org
 '(org-fancy-priorities-list (quote ("⏹" "⏹" "⏹")))
 '(org-ellipsis "")
 '(org-hide-emphasis-markers t)
 '(line-spacing 0.2)
 '(org-priority-faces (quote ((65 :inherit fixed-pitch :foreground "#E44955")
                              (66 :inherit fixed-pitch foreground "#fcb37b")
                              (67 :inherit fixed-pitch :foreground "#fcf7b0"))))
 '(org-bullets-bullet-list (quote (" "))))

(custom-theme-set-faces
 'bens-org
 ;'(default ((t (:inherit nil :stipple nil :background "#272C36" :foreground "#ECEFF4" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 101 :width normal :family "EtBembo"))))
 '(org-default ((t (:inherit nil :height 1.0 :family "EtBembo"))))
 '(org-todo ((t (:inherit fixed-pitch :height 1.0))))
 '(org-headline-done ((t (:foreground "#4C566A" :strike-through t :slant italic :family "EtBembo"))))
 '(org-level-1 ((t (:height 1.8 :inherit org-default :family "EtBembo"))))
 '(org-level-2 ((t (:slant italic :height 1.6 :family "EtBembo"))))
 '(org-level-3 ((t (:inherit nil :height 1.4 :family "EtBembo"))))
 '(org-level-4 ((t (:inherit nil :height 1.2 :family "EtBembo"))))
 '(org-level-5 ((t (:inherit nil :height 1.2 :family "EtBembo"))))
 '(org-tag ((t (:foreground "#86C0D1" :weight bold :family "EtBembo"))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:inherit nil :foreground "steel blue" :slant italic :weight semi-bold :family "EtBembo"))))
 '(org-quote ((t (:background "#373E4C" :slant italic :family "EtBembo"))))
 '(org-document-title ((t (:foreground "light gray" :weight ultra-bold :height 1.4 :family "EtBembo"))))
 '(org-document-info ((t (:slant italic :height 1.2 :family "EtBembo"))))
 '(org-document-info-keyword ((t (:inherit shadow :height 0.8 :family "EtBembo"))))
 '(org-date ((t (:foreground "#ECCC87" :family "Sans Mono")))))

(provide-theme 'bens-org)
