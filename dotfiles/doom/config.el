;;; config.el -*- lexical-binding: t; -*-


(setq doom-theme 'doom-tokyo-night)
;; Disable all syntax highlighting except comments
(setq doom-themes-enable-bold nil
      doom-themes-enable-italic nil)
;; Disable line numbers
(setq display-line-numbers-type nil)

;; remove default syntax highlighting
;; (global-font-lock-mode -1)
;; enable syntax highlighting for comments
;; (add-hook 'prog-mode-hook
;;         (lambda ()
;;         (font-lock-mode 1)
;;         (setq font-lock-keywords
;;                 `(("\\s<.*$" 0 (:foreground ,(doom-color
;; 'base6)))))))

;; Font configuration
(setq doom-font (font-spec :family "CommitMono Nerd Font" :size 32)
      doom-big-font (font-spec :family "CommitMono Nerd Font" :size 40)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 32))

;; Org mode configuration
(after! org
  (setq org-hide-emphasis-markers t))

;; Markdown mode configuration
(after! markdown-mode
  (setq-default markdown-hide-markup t)
  (setq markdown-list-item-bullets '("-")))

;; Org-roam configuration
(setq org-roam-directory "~/org-roam")

;; Use "public" tag to mark notes for publishing
(setq org-roam-db-location "~/org-roam/org-roam.db")

;; Capture templates for org-roam
(after! org-roam
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)
          ("p" "public" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :public:\n")
           :unnarrowed t))))
