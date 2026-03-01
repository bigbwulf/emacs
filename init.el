(load-file "~/.emacs.d/functions.el")

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (dichromacy)))
 '(inhibit-startup-screen t)
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(package-selected-packages
   (quote
    (fennel-mode plantuml-mode impatient-mode highlight-parentheses slime slime-volleyball magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ibuffer stuff
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-saved-filter-groups
      '(("default"
	 ("emacs-config" (or (filename . ".emacs.d")))
	 ("python" (mode . python-mode))
	 ("org" (mode . org-mode))
	 ("dired" (mode . dired-mode))
	 ("cppsource" (or
		    (name . "\\.cpp")	
		    (name . "\\.cxx")))
	 ("cppheader" (or
		    (name . "\\.h")
		    (name . "\\.hpp")
		    (name . "\\.hxx")))
	 ("Makefile" (or (mode . make-mode)
			(filename . "Makefile")))
	 ("gdb" (or (mode . gud-mode)))
	 ("REPL" (mode . repl-mode)))))

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "default")))

(setq ibuffer-expert t)
;;(setq ibuffer-show-empty-filter-groups nil)

;; set bsd style C coding
(setq c-default-style "bsd"
      c-basic-offset 4)
;; diplay line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; complete brakets 
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)



;; org stuff
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-use-fast-todo-selection t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))


(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	     ("WAITING" ("WAITING" . t))
	     ("HOLD" ("WAITING") ("HOLD"))
	     (done ("WAITING") ("HOLD"))
	     ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	     ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	     ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-directory "~/org")
(setq org-default-notes-file "~/org/refile.org")

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/refile.org")
	       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("r" "respond" entry (file "~/org/refile.org")
	       "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("n" "note" entry (file "~/org/refile.org")
	       "* %?\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("j" "Journal" entry (file "~/org/refile.org")
	       "* %?\n%U\n" :clock-in t :clock-resume t)
	      ("w" "org-protocol" entry (file "~/org/refile.org")
	       "* TODO Review %c\n%U\n" :immediate-finish t)
	      ("m" "Meeting" entry (file "~/org/refile.org")
	       "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
	      ("p" "Phone call" entry (file "~/org/refile.org")
	       "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	      ("h" "Habit" entry (file "~/org/refile.org")
	       "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(server-start)


; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))

(setq org-refile-use-outline-path t)

(setq org-outline-path-complete-in-steps nil)

(setq org-refile-allow-creating-parent-nodes (quote confirm))

(setq org-completion-use-ido t)

(setq ido-everywhere t)

(setq ido-max-directory-size 100000)

(ido-mode (quote both))

(setq ido-default-file-method 'selected-window)

(setq ido-default-buffer-method 'selected-window)

(setq org-indirect-buffer-display 'current-window)

(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)


(setq org-agenda-dim-blocked-tasks nil)

(setq org-agenda-compact-blocks t)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELLED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED/!NEXT"
                           ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED+WAITING|HOLD/!"
                           ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil))))

(org-clock-persistence-insinuate)

(setq org-clock-history-length 23)

(setq org-clock-in-resume t)

(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)

(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))

(setq org-clock-into-drawer t)

(setq org-clock-out-remove-zero-time-clocks t)

(setq org-clock-out-when-done t)

(setq org-clock-persist t)

(setq org-clock-persist-query-resume nil)

(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))

(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
	   (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
	   (bh/is-project-p))
      "TODO"))))



(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
    "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
    (interactive "p")
    (setq bh/keep-clock-running t)
    (if (equal major-mode 'org-agenda-mode)
	;; we're in the agenda
	(let* ((marker (org-get-at-bol 'org-hd-marker))
	       (tags (org-with-point-at marker (org-get-tags-at))))
	  (if (and (eq arg 4) tags)
	      (org-agenda-clock-in '(16))
	    (bh/clock-in-organization-task-as-default)))
      ;;not in agenda
      (save-restriction
	(widen)
	;; find tags on the current task
	(if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	    (org-clock-in '(16))
	  (bh/clock-in-orginization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  (let ((parent-task))
    (save-excursion
      (save-restriction
	(widen)
	(while (and (not parent-task) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq parent-task (point))))
	(if parent-task
	    (org-with-point-at parent-task
	      (org-clock-in))
	  (when bh/keep-clock-running
	    (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker))

(require 'term)

(defun mp-term-custom-settings ()
  (local-set-key (kbd "M-p") 'term-send-up)
  (local-set-key (kbd "M-n") 'term-send-down))
(add-hook 'term-load-hook #'mp-term-custom-settings)

(define-key term-raw-map (kbd "M-o") 'other-window)
(define-key term-raw-map (kbd "M-p") 'term-send-up)
(define-key term-raw-map (kbd "M-n") 'term-send-down)

(require 'dired-x)

(defun shell-other-window ()
  "Open a `shell' in a new window."
  (interactive)
  (let ((buf (eshell)))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-frame buf)))

;; (if (not (get-buffer "*eshell*"))
;;    (shell-other-window))

(global-set-key (kbd "C-x C-t") 'shell-other-window)

(defun open-ansi-term-right-split ()
  "Open a new ANSI term in split"
  (interactive)
  (split-window-right)
  (other-window 1)
  (ansi-term "/bin/bash"))

(defun open-ansi-term-below-split ()
  "Open a new ANSI term in split"
  (interactive)
  (split-window-below)
  (other-window 1)
  (ansi-term "/bin/bash"))


(define-key term-raw-map (kbd "C-c 3") 'open-ansi-term-right-split)
(define-key term-raw-map (kbd "C-c 1") 'open-ansi-term-below-split)


(setq dired-listing-switches "-alh")

(defun is-home-directory-open ()
  "check if home directory is open"
  (let ((home-directory (expand-file-name "~/")))
    (catch 'found
      (mapc (lambda (buffer)
	      (when (and (buffer-file-name buffer)
			 (string-prefix-p home-directory (buffer-file-name buffer)))
		(throw 'found t)))
	    (buffer-list))
      nil)))


  

(if (not (is-home-directory-open))
    (dired "~/"))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(setq package-archives
      '(("melpa-stable" . "https://stable.melpa.org/packages/")
	("org" . "https://orgmode.org/elpa")
	("elpa" . "https://elpa.gnu.org/packages/")))
    
(add-hook 'text-mode'hook #'auto-fill-mode)
(setq-default fill-column 80)
(add-hook 'prog-mode-hooks #'auto-fill-mode)

(setq org-agenda-files '("~/org"))

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)  ; in my case /bin/bash
   (scheme . t)
   (python . t)
   (ledger . t)
   (sed . t)
   (awk . t)
   (C . t)
   (lisp . t)
   (plantuml . t)))


(global-visual-line-mode t)



(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)
(add-to-list 'eshell-modules-list 'eshell-smart)

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
	   (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
    (current-buffer)))


(require 'subr-x)



(add-to-list
  'org-src-lang-modes '("plantuml" . plantuml))

(setq plantuml-executable-path "/usr/bin/plantuml")
(setq plantuml-default-exec-mode 'executable)

(org-babel-do-load-languages
  'org-babel-load-languages
  '((plantuml . t)))


;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

(setq plant-output-type 'png)
