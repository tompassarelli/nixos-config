;;; config.el -*- lexical-binding: t; -*-


(setq doom-theme 'doom-tokyo-night)

;; Font configuration
(setq doom-font (font-spec :family "CommitMono Nerd Font" :size 32)
      doom-big-font (font-spec :family "CommitMono Nerd Font" :size 40)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 32))
;; no syntax highlighting
(global-font-lock-mode -1)

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
