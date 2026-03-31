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

;; [[file:init.org::*Eshell][Eshell:1]]
(use-package eshell-info-banner
  :ensure t
  :defer t
  :hook (eshell-banner-load . eshell-info-banner-update-banner))
;; Eshell:1 ends here

;; [[file:init.org::*Org Babel config][Org Babel config:1]]
(setq inferior-lisp-program "sbcl")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((lisp . t) (plantuml .t)))

(setq org-babel-lisp-eval-fn #'slime-eval)

(add-hook 'org-babel-after-execute-hook
        (lambda ()
          (when org-inline-image-overlays
            (org-redisplay-inline-images))))
;; Org Babel config:1 ends here

;; [[file:init.org::*Helm-bibtex][Helm-bibtex:1]]
(use-package helm-bibtex
  :config
  (setq bibtex-completion-pdf-field "File"
        bibtex-completion-notes-path org-directory
        bibtex-completion-additional-search-fields '(keywords))
  :bind
  (("C-c n B" . helm-bibtex)))
;; Helm-bibtex:1 ends here

;; [[file:init.org::*Org][Org:1]]
(setq org-use-fast-todo-selection t)

    (setq org-treat-S-cursor-todo-selection-as-state-change nil)




    (setq org-todo-keywords
          (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                  (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MEETING"))))

    (setq org-todo-keyword-faces
          (quote (("TODO" :foreground "red" :weight bold)
                  ("NEXT" :foreground "blue" :weight bold)
                  ("DONE" :foreground "forest green" :weight bold)
                  ("WAITING" :foreground "orange" :weight bold)
                  ("HOLD" :foreground "magenta" :weight bold)
                  ("CANCELLED" :foreground "forest green" :weight bold))))

    (setq org-agenda-files (list "~/org/denote" "~/org"))

    (define-key global-map (kbd "C-c c") 'org-capture)
    (require 'org-protocol)

    (setq org-agenda-custom-commands
          '(("g" "Get Things Done (GTD)"
             ((agenda ""
                      ((org-agenda-span 'day)
                       (org-agenda-skip-function
                        '(org-agenda-skip-entry-if 'deadline))
                       (org-deadline-warning-days 0)))
    	  (agenda ""
                      ((org-agenda-entry-types '(:deadline))
                       (org-deadline-warning-days 7)
    		   (org-agenda-time-grid nil)
                       (org-agenda-overriding-header "\nDeadlines\n")))
              (todo "NEXT"
                    ((org-agenda-skip-function
                      '(org-agenda-skip-entry-if 'deadline))
                     (org-agenda-prefix-format "  %i %-12:c [%e] ")
                     (org-agenda-overriding-header "\nTasks\n")))                
              (tags "inbox"
                    ((org-agenda-prefix-format "  %?-12t% s")
                     (org-agenda-overriding-header "\nInbox\n")))
              (tags "CLOSED>=\"<today>\""
                    ((org-agenda-overriding-header "\nCompleted today\n")))
    	  (todo "WAITING"
    		((org-agenda-overriding-header "\nWaiting\n")))))
    	("c" . "Contexts (GTD)")
    	("cs" "Stand-up"
    	 tags-todo "stand-up")
    	("cp" "Sprint Planning"
    	 tags-todo "sprint-planning")
    	("cr" "Sprint Retrospective"
    	 tags-todo "sprint-retro")
    	("cw" "Sprint Review"
    	 tags-todo "sprint-review")
    	("cb" "Sprint Backlog Refinement"
    	 tags-todo "sprint-backlog")
    	("ct" "SSA Roundtable"
    	 tags-todo "ssa-rt")
    	("cj" "James"
    	 tags-todo "james")
    	("ch" "Travis (branchHead)"
    	 tags-todo "travis")))
(setq org-tag-alist '(("sprint-planning" . ?p)
		      ("sprint-retro" . ?r)
		      ("sprint-review" . ?w)
		      ("sprint-backlog" . ?b)
		      ("ssa-roundtable" . ?t)
		      ("@james" . ?j)
		      ("@travis" . ?t)
		      ("@fosty" . ?f)
		      ("@chrisb" . ?c)
		      ("@yousseff" . ?y)))
    ;; ;;
  ;;  (setq org-refile-targets
          ;; '(("~/org/projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")
          ;; ("~/org/someday.org" :level . 1)))


          (setq org-refile-targets '((org-agenda-files :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")
    				 (org-agenda-files :maxlevel . 10)))

          (setq org-refile-use-outline-path 'file)
          (setq org-outline-path-complete-in-steps nil)

          (setq org-agenda-hide-tags-regexp ".")

          (setq org-agenda-prefix-format
                '((agenda . " %i %-12:c%?-12t% s")
                  (todo   . " ")
                  (tags   . " %i %-12:c")
                  (search . " %i %-12:c")))

          (define-key global-map (kbd "C-c a") 'org-agenda)

          (setq org-log-done 'time)


          (defvar ajb/inbox-file "~/org/inbox.org" "The location of my inbox file.")
          (defvar ajb/org-dir "~/org")


          (use-package org
    	:after
    	denote
    	:bind
    	(("C-c c" . org-capture)
    	 ("C-c l" . org-store-link))
    	:custom
    	(org-default-notes-file "~/org/inbox.org")
    	(org-capture-bookmark nil)
    	;; Capture templates
    	(org-capture-templates
    	 '(("f" "Fleeting note" item
                (file+headline org-default-notes-file "Notes")
                "- %?")
               ("p" "Permanent note" plain
                (file denote-last-path)
                #'denote-org-capture
                :no-save t
                :immediate-finish nil
                :kill-buffer t
                :jump-to-captured t)
               ("i" "New inbox task" entry
                (file+headline org-default-notes-file "Tasks")
                "* TODO %i%?")
               ;; todo seems to be a bug? here where org-protocol can't open the bib file if it is open in a buffer??
               ;; maybe try and test it with a org file instead of bib, never seen it before
               ("w" "Web entry" plain
                (file "~/org/denote/references.bib")
                (function
                 (lambda()
        	       (let ((test (ajb/random-string))) (string-join (list "@online{" test ", title=\"%:description\", url=%:link}"))))))
               ("l" "Link Annotation" entry
        	    (file+headline "~/org/inbox.org" "Web References") "** %:annotation"))))
;; Org:1 ends here

;; [[file:init.org::*Denote][Denote:1]]
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

(use-package denote-journal
  :ensure t
  ;; Bind those to some key for your convenience.
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year))
;; Denote:1 ends here

;; [[file:init.org::*Citar][Citar:1]]
(use-package citar
  :ensure t
  :defer t
  :custom
  (citar-bibliography '("~/org/denote/references.bib"))
  (citar-open-always-create-notes nil)
  (citar-library-paths '("~/org/denote/"))
  :init
  (fido-vertical-mode 1)
  :bind ("C-c w c" . citar-create-note))
;; Citar:1 ends here

;; [[file:init.org::*Citar-Denote][Citar-Denote:1]]
(use-package citar-denote
  :ensure t
  :demand t ;; Ensure minor mode loads
  :after (:any citar denote)
  :custom
  ;; Package defaults
  (citar-denote-file-type 'org)
  (citar-denote-keyword "bib")
  (citar-denote-signature nil)
  (citar-denote-subdir nil)
  (citar-denote-template nil)
  (citar-denote-title-format "title")
  (citar-denote-title-format-andstr "and")
  (citar-denote-title-format-authors 1)
  (citar-denote-use-bib-keywords nil)
  :preface
  (bind-key "C-c w n" #'citar-denote-open-note)
  :init
  (citar-denote-mode)
  ;; Bind all available commands
  :bind (("C-c w d" . citar-denote-dwim)
	 ("C-c w e" . citar-denote-open-reference-entry)
	 ("C-c w a" . citar-denote-add-citekey)
	 ("C-c w k" . citar-denote-remove-citekey)
	 ("C-c w r" . citar-denote-find-reference)
	 ("C-c w l" . citar-denote-link-reference)
	 ("C-c w f" . citar-denote-find-citation)
	 ("C-c w x" . citar-denote-nocite)
	 ("C-c w y" . citar-denote-cite-nocite)
	 ("C-c w z" . citar-denote-nobib)))
;; Citar-Denote:1 ends here

;; [[file:init.org::*Bibtex][Bibtex:1]]
(use-package bibtex
  :custom
  (bibtex-dialect 'BibTeX)
  (bibtex-user-optional-fields
   '(("keywords" "Keywords to describe the entry" "")
     ("file" "Link to a document file." "" )))
  (bibtex-align-at-equal-sign t)
  (bibtex-set-dialect 'biblatex))
;; Bibtex:1 ends here

;; [[file:init.org::*Random string][Random string:1]]
(defun ajb/random-string (&optional Ncount)
  "return a random string of length Ncount.
The possible chars are: 2 to 9, upcase or lowercase English alphabet but no a e i o u, no L l and no 0 1.
First char is always a letter

URL `http://xahlee.info/emacs/emacs/elisp_insert_random_number_string.html'
Created: 2024-04-03
Version: 2025-10-16"
  (let* ((xletters "BCDFGHJKMNPQRSTVWXYZbcdfghjkmnpqrstvwxyz")
         (xcharset (concat xletters "23456789"))
         (xlen (length xcharset))
         (xtotal-count (if Ncount Ncount 5))
         (xresult (make-list xtotal-count 0)))
    (setq xresult (mapcar (lambda (_) (aref xcharset (random xlen))) xresult))
    (setcar xresult (aref xletters (random (length xletters))))
    (concat xresult)))
;; Random string:1 ends here

;; [[file:init.org::*Org beautify][Org beautify:1]]
(setq org-hide-emphasis-markers t)
;; Org beautify:1 ends here

;; [[file:init.org::*Org beautify][Org beautify:2]]
(font-lock-add-keywords 'org-mode
                       '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
;; Org beautify:2 ends here

;; [[file:init.org::*Org beautify][Org beautify:3]]
(use-package org-bullets
:config
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;; Org beautify:3 ends here

;; [[file:init.org::*Org beautify][Org beautify:4]]
(let* ((variable-tuple
        (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
              ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
              ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
              ((x-list-fonts "Verdana")         '(:font "Verdana"))
              ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
              (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))
;; Org beautify:4 ends here

;; [[file:init.org::*Flyspell][Flyspell:1]]
(add-hook 'org-mode-hook 'turn-on-flyspell)
;; Flyspell:1 ends here
