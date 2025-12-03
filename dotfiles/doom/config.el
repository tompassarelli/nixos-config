;;; config.el -*- lexical-binding: t; -*-


(setq doom-theme 'doom-one)
;; Override background to Tokyo Night color
(after! doom-themes
  (custom-set-faces!
    '(default :background "#1a1b26")
    '(fringe :background "#1a1b26")
    '(solaire-default-face :background "#1a1b26")
    '(solaire-fringe-face :background "#1a1b26")))

;; Disable all syntax highlighting except comments
(setq doom-themes-enable-bold nil
      doom-themes-enable-italic nil)
;; Disable line numbers
(setq display-line-numbers-type nil)

;; Hide modeline by default
(global-hide-mode-line-mode +1)

;; Disable syntax highlighting globally, except org-mode
(global-font-lock-mode -1)
(add-hook 'org-mode-hook #'font-lock-mode)

;; Font configuration
(setq doom-font (font-spec :family "CommitMono Nerd Font" :size 32)
      doom-big-font (font-spec :family "CommitMono Nerd Font" :size 40)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 32))

;; Disable automatic eldoc popups
(setq eldoc-idle-delay most-positive-fixnum)

;; Kill the other window without switching to it
(defun kill-other-window ()
  (interactive)
  (if (one-window-p)
      (message "No other window to kill")
    (save-selected-window
      (other-window 1)
      (delete-window))))
(map! :leader
      :desc "Kill other window"
      "w o" #'kill-other-window)

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
