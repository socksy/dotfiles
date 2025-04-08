;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(setq doom-localleader-key ",")
(setq expand-region-contract-fast-key "V")

(map! :leader
;      "A" nil
;      "X" nil
      )

(map! :leader 
      :desc "M-x"                   "SPC" #'execute-extended-command
      :desc "Find file in project"  "." #'projectile-find-file
      :desc "Expand region"         "v" #'er/expand-region
      :desc "Switch to last buffer" "TAB" #'previous-buffer)

(defun neotree-open-this ()
  (interactive)
  (if (neo-global--window-exists-p)
      (neotree-hide)
    (+neotree/find-this-file)))

(map! :leader
      ;; undoes all the other window bindings?
      (:prefix "w"
         :nv :desc "Split window right" "|"  #'split-window-right
         :nv :desc "Split window below" "-"  #'split-window-below
         :nvie :desc "Winner redo" "U" #'winner-redo)

      (:prefix "c"
        ;; also works for cider jumping
        :nv :desc "Jump back" "b"  #'dumb-jump-back)

      (:prefix "k"
        :nv :desc "Wrap with ()" "w" #'sp-wrap-round
        :nv :desc "Unwrap with ()" "W" #'sp-unwrap-sexp
        :nv :desc "Barf" "b" #'sp-forward-barf-sexp
        :nv :desc "Slurp" "s" #'sp-forward-slurp-sexp
        :nv :desc "Raise" "r" #'sp-raise-sexp
        :nv :desc "Transpose" "t" #'sp-transpose-sexp)

      (:prefix "j"
        :nv :desc "Jump to symbol" "i" #'imenu
        :nv :desc "Jump to symbol across buffers" "I" #'imenu-anywhere
        :nv :desc "Jump to link" "l" #'ace-link
        :nv :desc "Avy jump" "j" #'avy-goto-char-timer)

      (:prefix "p"
        :nv :desc "Find file in project" "f" #'projectile-find-file
        :nv :desc "Neotree" "t" #'neotree-open-this)

      (:prefix "o"
        :nv :desc "Neotree for this file" "p" #'neotree-open-this)

      (:prefix "b"
        :nv :desc "Switch buffer"               "b" #'switch-to-buffer
        :nv :desc "Delete buffer"               "d" #'kill-this-buffer
        :nv :desc "Recent files"                "r" #'recentf-open-files)

      (:when (modulep! :tools magit)
        (:prefix-map ("g" . "git")
          :desc "Magit status"              "s" #'magit-status
          :desc "Git link"                  "ll" #'git-link
          :desc "Magit switch branch"       "B" #'magit-branch-checkout
          :desc "Magit blame"               "b" #'magit-blame-addition)))

(after! cider
  (map! :localleader
        :map (clojure-mode-map clojurescript-mode-map)
                                        ; (:prefix "g"
                                        ;   :nv "g" #'spacemacs/clj-find-var)
        (:prefix "h"
          :nv "h" #'cider-doc)
        (:prefix "e"
          :nv "f" #'cider-eval-defun-at-point
          :nv "b" #'cider-eval-buffer
          :nv "c" #'cider-pprint-eval-last-sexp-to-comment
          :nv "h" #'cider-eval-sexp-up-to-point)))

(after! go-mode
  (map! :localleader
        :map go-mode-map
        :nv "e" nil
        (:prefix "e"
         :nv "e" #'gorepl-eval-line
         :nv "r" #'gorepl-eval-region
         :nv "q" #'gorepl-quit)))

(after! lsp-mode
  (map! :localleader
        (:prefix "f"
                 :nv "r" #'lsp-find-references)))

(after! sql-mode
  (map! (:localleader
          (:map (clojure-mode-map clojurescript-mode-map)
            ;; (:prefix "g"
            ;;   :nv "g" #'spacemacs/clj-find-var)
            (:prefix "h"
              :nv "h" #'cider-doc)
            (:prefix "e"
              :nv "f" #'cider-eval-defun-at-point
              :nv "b" #'cider-eval-buffer)))))

(after! sql-mode
  (map! :localleader
        :map sql-mode-map
        :prefix "e"
        :n "e" #'sql-send-paragraph
        :v "e" #'sql-send-region
        :nv "f" #'sql-send-paragraph
        :nv "b" #'sql-send-buffer))

;;; CIDER has some problems with messing with company mode shortcuts, these reset them
;; https://github.com/hlissner/doom-emacs/issues/1335#issuecomment-619022468
;(defun custom/unset-company-maps (&rest unused)
;  "Set default mappings (outside of company).
;    Arguments (UNUSED) are ignored."
;  (general-def
;    :states 'insert
;    :keymaps 'override
;    "<down>" nil
;    "<up>"   nil
;    "RET"    nil
;    [return] nil
;    "C-n"    nil
;    "C-p"    nil
;    "C-j"    nil
;    "C-k"    nil
;    "C-h"    nil
;    "C-u"    nil
;    "C-d"    nil
;    "C-s"    nil
;    "C-S-s"   (cond ((modulep! :completion helm) nil)
;                    ((modulep! :completion ivy)  nil))
;    "C-SPC"   nil
;    "TAB"     nil
;    [tab]     nil
;    [backtab] nil))
;
;(defun custom/set-company-maps (&rest unused)
;  "Set maps for when you're inside company completion.
;    Arguments (UNUSED) are ignored."
;  (general-def
;    :states 'insert
;    :keymaps 'override
;    "<down>" #'company-select-next
;    "<up>" #'company-select-previous
;    "RET" #'company-complete
;    [return] #'company-complete
;    "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
;    "C-n"     #'company-select-next
;    "C-p"     #'company-select-previous
;    "C-j"     #'company-select-next
;    "C-k"     #'company-select-previous
;    "C-h"     #'company-show-doc-buffer
;    "C-u"     #'company-previous-page
;    "C-d"     #'company-next-page
;    "C-s"     #'company-filter-candidates
;    "C-S-s"   (cond ((modulep! :completion helm) #'helm-company)
;                    ((modulep! :completion ivy)  #'counsel-company))
;    "C-SPC"   #'company-complete-common
;    "TAB"     #'company-complete-common-or-cycle
;    [tab]     #'company-complete-common-or-cycle
;    [backtab] #'company-select-previous))

(after! cider
  (add-hook 'company-completion-started-hook 'custom/set-company-maps)
  (add-hook 'company-completion-finished-hook 'custom/unset-company-maps)
  (add-hook 'company-completion-cancelled-hook 'custom/unset-company-maps))


;(map! :desc "Create sparse tree" :nev "SPC / s" #'org-sparse-tree)
;(map! :desc "Create sparse tags tree" :nev "SPC / t" #'org-tags-sparse-tree)

(after! org-mode
 ; (map! :desc "Archive heading" :nev ", a" #'org-archive-subtree)
  )

(define-key evil-motion-state-map [remap evil-next-line] #'evil-next-visual-line)
(define-key evil-motion-state-map [remap evil-previous-line] #'evil-previous-visual-line)
