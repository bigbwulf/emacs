;; set up package sources
(require 'package)
;;; Code:
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))



;;set bsd style C coding

(setq-default c-default-style "linux")

;; diplay line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; complete brakets
(electric-pair-mode 1)

(setq-default electric-pair-inhibit-predicate
      (lambda (c)
	(if (char-equal c ?<) t (electric-pair-default-inhibit c))))
      

(setq-default electric-pair-preserve-balance nil)



(global-visual-line-mode t)


;; org-mode





;; start Emacs server
(load "server")
(unless (server-running-p) (server-start))

;; ibuffer stuff
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq ibuffer-saved-filter-groups
      '(("home"
	 ("emacs" (mode . emacs-lisp-mode))
	 ("dired" (mode . dired-mode))
	 ("slime" (mode . slime-repl-mode))
	 ("org" (mode . org-mode))
	 ("cpp" (mode . c++-mode))
	 ("lisp" (mode . lisp-mode))
	 ("build" (or (mode . make-mode)
		      (mode . cmake-mode)))
	 ("gdb" (or (mode . gud-mode))))))

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))

(setq ibuffer-expert t)

;; open alias
(defalias 'emc 'find-file)

(use-package doom-themes
	     :ensure t
	     :config
	     (setq doom-themes-enable-bold t)
	     (setq doom-themes-enable-italic t)
	     (load-theme 'doom-one t)

	     (with-eval-after-load 'doom-themes 
	       (doom-themes-neotree-config))
	     (doom-themes-visual-bell-config)
	     (setq doom-themes-treemacs-theme "doom-atom")
	     (doom-themes-treemacs-config)
	     (doom-themes-org-config))








(use-package eshell-info-banner
  :ensure t
  :defer t
  :hook (eshell-banner-load . eshell-info-banner-update-banner))

(setq inferior-lisp-program "sbcl")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((lisp . t)))

(setq org-babel-lisp-eval-fn #'slime-eval)

(require 'org-tempo)


;; tags for code navigation
(use-package ggtags
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
	    (lambda ()
	      (when (derived-mode-p 'c-mode 'c++-mode)
		(ggtags-mode 1)))))


(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-confirm-babel-evaluate nil)
 '(org-src-tab-acts-natively t)
 '(org-structure-template-alist
   '(("a" . "export ascii")
     ("c" . "center")
     ("C" . "comment")
     ("e" . "example")
     ("E" . "export")
     ("h" . "export html")
     ("l" . "src lisp :results output")
     ("q" . "quote")
     ("s" . "src")
     ("v" . "verse")))
 '(package-selected-packages
   '(citar-denote denote-org consult-notes denote yasnippet-snippets which-key use-package treemacs slime rainbow-delimiters rainbow-blocks racket-mode projectile org-roam-ui neotree markdown-mode magit image-dired+ highlight-parentheses helm-bibtex ggtags gdscript-mode flycheck eshell-toggle eshell-syntax-highlighting eshell-info-banner eldoc-box eglot doom-themes cyberpunk-theme company-fuzzy company-flx clang-format auto-complete all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; (use-package org-roam
;;   :after org
;;   :custom
;;   (setq org-roam-directory (file-truename "~/org-roam"))
;;   ;; :init
;;   ;; (org-roam-setup)
;;   :bind (("C-c n f" . org-roam-node-find)
;; 	 ("C-c n r" . org-id-get-random)
;; 	 (:map org-mode-map
;; 	       ("C-c n i" . org-roam-node-insert)
;; 	       ("C-c n o" . org-id-get-create)
;; 	       ("C-c n t" . org-roam-tag-add)
;; 	       ("C-c n a" . org-roam-alias-add)
;; 	       ("C-c n l" . org-roam-buffer-toggle))))

(use-package helm-bibtex
  :config
  (setq bibtex-completion-pdf-field "File"
	bibtex-completion-notes-path org-directory
	bibtex-completion-additional-search-fields '(keywords))
  :bind
  (("C-c n B" . helm-bibtex)))


(defvar ajb/inbox-file "~/org/inbox.org" "The location of my inbox file.")
(defvar ajb/org-dir "~/org")


(use-package org
  :after
  denote
  :bind
  (("C-c c" . org-capture)
   ("C-c l" . org-store-link))
  :custom
  (org-default-notes-file ajb/inbox-file)
  (org-capture-bookmark nil)
  ;;capture templates
  (org-capture-templates
   '(("f" "Fleeting note" item
      (file+headline org-default-notes-file "Notes")
      "- %?")
     ("p" "Permanent note" plain
      (file denote-last-path)
      #'denote-org-capture
      :no-save t
      :immediate finish nil
      :kill-buffer
      :jump-to-captured t)
     ("t" "New task" entry
      (file+headline org-default-notes-file "Tasks")
      "* TODO %i%?"))))


(defvar ajb/denote-dir "~/org/denote")
(use-package denote
  :init
  (require 'denote-org)
  (denote-rename-buffer-mode 1)
  :custom
  (denote-directory ajb/denote-dir)
  :hook
  (dired-mode . denote-dired-mode)
  :custom-face
  (denote-faces-link ((t (:slant italic)))))

(use-package consult-notes
  :commands (consult-notes
	     consult-notes-search-in-all-notes)
  :custom
  (consult-notes-file-dir-sources
   `(("Denote" ?d ,ajb/denote-dir)))
  :config
  (when (locate-library "denote")
    (consult-notes-denote-mode)))

(use-package citar
  :ensure t
  :defer t
  :custom
  (citar-bibliography '("~/org/references.bib"))
  (citar-open-always-create-notes nil)
  :init
  (fido-vertical-mode 1)
  :bind ("C-c w c" . citar-create-note))

(use-package citar-denote
  :ensure t
  :demand t
  :after (:any citar denote)
  :custom
  (citar-open-always-create-notes t)
  :init
  (citar-denote-mode))





