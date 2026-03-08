;; [[file:init.org::*Put all auto generated configurations in a seperate file][Put all auto generated configurations in a seperate file:1]]
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)
;; Put all auto generated configurations in a seperate file:1 ends here

;; [[file:init.org::*Set up the package manager][Set up the package manager:1]]
;; set up package sources
(require 'package)
(package-initialize)
(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
;; Set up the package manager:1 ends here

;; [[file:init.org::*Set up use-package][Set up use-package:1]]
(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)))
;; Set up use-package:1 ends here

;; [[file:init.org::*Do not show confusing warning when we install packages][Do not show confusing warning when we install packages:1]]
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))
;; Do not show confusing warning when we install packages:1 ends here

;; [[file:init.org::*Make C-g a bit more helpful][Make C-g a bit more helpful:1]]
(defun ajb/keyboard-quit-dwim ()
  "Do-What-I-Mean behavior for a general 'keyboard-quit'.
  This will quit the minibuffer even if we're not focused on it.
  DWIM Behaviour:

  - When the region is active, disable it
  - when a minibuffer is open, but not focused, close the minibuffer
  - when the completions buffer is selected, close it
  - in every other case use the regular 'keyboard-quit'"
  (interactive)
  (cond
    ((region-active-p)
     (keyboard-quit))
    ((derived-mode-p 'completion-list-mode)
     (delete-completion-window))
    ((> (minibuffer-depth) 0)
     (abord-recursive-edit)
    ((t
     keyboard-quite)))))

(define-key global-map (kbd "C-g") #'ajb/keyboard-quit-dwim)
;; Make C-g a bit more helpful:1 ends here

;; [[file:init.org::*Disable graphical bars][Disable graphical bars:1]]
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
;; Disable graphical bars:1 ends here

;; [[file:init.org::*Configure theme][Configure theme:1]]
(use-package doom-themes
	     :ensure t
	     :config
	     (setq doom-themes-enable-bold t)
	     (setq doom-themes-enable-italic t)
	     (load-theme 'doom-one t)
	     (doom-themes-visual-bell-config)
	     (doom-themes-org-config))
;; Configure theme:1 ends here

;; [[file:init.org::*Use icon fonts][Use icon fonts:1]]
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))
;; Use icon fonts:1 ends here

;; [[file:init.org::*Vertico][Vertico:1]]
(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))
;; Vertico:1 ends here

;; [[file:init.org::*Marginalia][Marginalia:1]]
(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))
;; Marginalia:1 ends here

;; [[file:init.org::*Orderless][Orderless:1]]
(use-package orderless
  :ensure t
  :config
    (setq completion-styles '(orderless basic))
    (setq completion-category-defaults nil)
    (setq completion-category-overrides nil))
;; Orderless:1 ends here

;; [[file:init.org::*Savehist][Savehist:1]]
(use-package savehist
  :ensure nil ; built in to emacs
  :hook (after-init . savehist-mode))
;; Savehist:1 ends here

;; [[file:init.org::*Corfu][Corfu:1]]
(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :config
    (setq tab-always-indent 'complete)
(setq corfu-preview-current nil)
(setq corfu-min-width 20)

(setq corfu-popupinfo-delay '(1.25 . 0.5))
(corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

;; Sort by input history (no need to modify `corfu-sort-function').
(with-eval-after-load 'savehist
  (corfu-history-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history)))
;; Corfu:1 ends here

;; [[file:init.org::*Dired proper][Dired proper:1]]
(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))
;; Dired proper:1 ends here

;; [[file:init.org::*Dired-subtree][Dired-subtree:1]]
(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))
;; Dired-subtree:1 ends here

;; [[file:init.org::*Trashed][Trashed:1]]
(use-package trashed
:ensure t
:commands (trashed)
:config
(setq trashed-action-confirmer 'y-or-n-p)
(setq trashed-use-header-line t)
(setq trashed-sort-key '("Date deleted" . t))
(setq trashed-date-format "%Y-%m-%d %H:%M:%S"))
;; Trashed:1 ends here

;; [[file:init.org::*Undocumented][Undocumented:1]]
(require 'org-protocol)
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))



;;set bsd style C coding
(setq-default c-default-style "linux")




(setq-default electric-pair-inhibit-predicate
              (lambda (c)
                (if (char-equal c ?<) t (electric-pair-default-inhibit c))))


(setq-default electric-pair-preserve-balance nil)



(global-visual-line-mode t)
;; Undocumented:1 ends here

;; [[file:init.org::*Emacs Server][Emacs Server:1]]
(load "server")
(unless (server-running-p) (server-start))
;; Emacs Server:1 ends here

;; [[file:init.org::*Ibuffer][Ibuffer:1]]
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
;; Ibuffer:1 ends here

;; [[file:init.org::*Aliases][Aliases:1]]
(defalias 'emc 'find-file)
;; Aliases:1 ends here

;; [[file:init.org::*Aliases][Aliases:2]]
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
;; Aliases:2 ends here
