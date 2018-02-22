;;; packages.el --- My Emacs package configuration.
;;; Author: Ali Ghahraei Figueroa
;;; Commentary:
;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

; TODO: Fix
(require 'use-package); Instala/configura req-package
(setq use-package-always-ensure t)


(use-package page-break-lines
  :diminish page-break-lines-mode
  :config
  (global-page-break-lines-mode))

(use-package projectile
  :config
  (add-hook 'prog-mode-hook 'projectile-mode))

(use-package dashboard
  :after (page-break-lines projectile)
  :demand
  :bind (:map dashboard-mode-map
			  ("<down-mouse-1>" . nil)
			  ("<mouse-1>" . widget-button-click)
			  ("<mouse-2>" . widget-button-click))

  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items
		'((recents  . 5)
		  (bookmarks . 5)
		  (projects . 5))))

(use-package smart-mode-line)

(use-package smart-mode-line-powerline-theme
  :after (smart-mode-line)
  :config
  (defvar sml/theme 'powerline)
  (sml/setup))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox))

;; (use-package kaolin-themes
;;   :config
;;   (load-theme 'kaolin-eclipse))

;;; Not hooking to prog-mode because of the scratch buffer (wouldn't be lazy)
(use-package flycheck
  :config
  (setq flycheck-python-flake8-executable "/usr/local/bin/flake8")
  (add-hook 'prog-mode-hook 'flycheck-mode)
  (add-hook 'html-mode 'flycheck-mode)
  (flycheck-add-mode 'html-tidy 'html-mode))

(use-package company
  :commands company-mode
  :init
  (add-hook 'prog-mode-hook 'company-mode)
  :config
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0))

(use-package company-php
  :after (company)
  :config
  (ac-php-core-eldoc-setup) ;; enable eldoc
  ;(make-local-variable 'company-backends)
  (add-to-list 'company-backends 'company-ac-php-backend))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package diminish)

;;;;;;;;;;;;;;;;;;;;
;; ¡Cosas flojas! ;;
;;;;;;;;;;;;;;;;;;;;

(use-package yaml-mode
  :mode "\\.yml\\'")

(use-package neotree
  :bind ("C-c n" . neotree-project-dir)
  :config
  (defun neotree-project-dir ()
	"Open NeoTree using the git root."
	(interactive)
	(if (projectile-project-p)
		(let ((project-dir (projectile-project-root))
			  (file-name (buffer-file-name)))
		  (neotree-toggle)
		  (if project-dir
			  (if (neo-global--window-exists-p)
				  (progn
					(neotree-dir project-dir)
					(neotree-find file-name))
				(message "Could not open neotree."))
			(message
			 "Could not find git project root.")))
	  (neotree-toggle)))
  (setq neo-smart-open t))

(use-package elixir-mode
  :mode "\\.ex\\'")

(use-package web-mode
  :mode ("\\.html\\'" "\\.blade.php\\'"))

(use-package company-web
  :after (company web-mode)
  :config
  (company-web-html))

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package typescript-mode
  :mode "\\.ts\\'")

(use-package tide
  :after (company typescript-mode)
  :config
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  ;; formats the buffer before saving
  (add-hook 'before-save-hook 'tide-format-before-save)
  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t))

(use-package racer
  :after (company rust-mode))

(use-package flycheck-rust
  :after (flycheck rust-mode))

(use-package aggressive-indent
  :bind ("C-c g" . aggressive-indent-mode))

(use-package anaconda-mode
  :commands anaconda-mode
  :init
  (add-hook 'python-mode-hook 'anaconda-mode))

(use-package company-anaconda
  :after company anaconda-mode
  :config
  (add-to-list 'company-backends 'company-anaconda))

(use-package rust-playground
  :init
  (defun rust-playground-split()
	(interactive)
	(split-window-right)
	(other-window 1)
	(rust-playground))
  :bind ("C-c r" . rust-playground-split)
  :config
  (defun rust-playground()
	"Run playground for Rust language in a new buffer."
	(interactive)
	(let ((snippet-file-name (rust-playground-snippet-file-name)))
	  (switch-to-buffer (create-file-buffer snippet-file-name))
	  (add-hook 'kill-buffer-hook 'rust-playground-on-buffer-kill nil t)
	  (rust-playground-insert-template-head "snippet of code")
	  (insert "fn main() {
	println!(\"Results:\");

}")
	  (backward-char 3)
	  (require 'rust-mode)
	  (rust-mode)
	  (rust-playground-mode)
	  (set-visited-file-name snippet-file-name t)))

  (with-eval-after-load 'rust-playground
	(define-key rust-playground-mode-map (kbd "C-x k") (lambda ()
														  (interactive)
														  (rust-playground-rm)
														  (delete-window))))
  (setq rust-playground-confirm-deletion nil))

(use-package multi-term
  :init
  (defun term-toggle()
	(interactive)
	(multi-term-dedicated-toggle)
	(other-window 1))
  :bind (("C-;" . term-toggle)
		 ("C-c t" . multi-term))
  :config
  (setq multi-term-program "/bin/bash")
  (setq term-unbind-key-list (quote ("C-z" "C-x" "C-c" "C-h" "C-y" "<ESC>" "C-<" "C-b")))
  (setq term-bind-key-alist
   (quote
	(("C-c C-c" . term-interrupt-subjob)
	 ("C-c C-e" . term-send-esc)
	 ("C-p" . previous-line)
	 ("C-n" . next-line)
	 ("C-s" . isearch-forward)
	 ("C-m" . term-send-return)
	 ("C-y" . term-paste)
	 ("M-f" . term-send-forward-word)
	 ("M-b" . term-send-backward-word)
	 ("M-o" . term-send-backspace)
	 ("M-p" . term-send-up)
	 ("M-n" . term-send-down)
	 ("M-M" . term-send-forward-kill-word)
	 ("M-N" . term-send-backward-kill-word)
	 ("<C-backspace>" . term-send-backward-kill-word)
	 ("C-r" . term-send-reverse-search-history)
	 ("M-r" . isearch-backward)
	 ("M-d" . term-send-delete-word)
	 ("M-," . term-send-raw)
	 ("M-." . comint-dynamic-complete)))))

(use-package realgud
  :bind (("C-." . load-pdb)
		 ("C-:" . realgud:pdb))
  :config
  (defun load-pdb ()
	" Load pdb with RealGUD using the correct path and current buffer name"
	(interactive)
	(realgud:pdb (concat "python -m pdb " (buffer-name)))))

(use-package scala-mode
  :mode ("\\.sc\\'" "\\.scala\\'"))

(use-package haskell-mode
  :mode "\\.hs\\'")

(use-package org
  :bind ("C-c a" . org-agenda-list)
  :config
  (setq org-lowest-priority 68)

  ;; Agenda config
  (add-hook 'org-finalize-agenda-hook
			(lambda ()
			  (save-excursion
				(goto-char (point-min))
				(while (re-search-forward "todos:      Scheduled:.*#D" nil t)
				  (add-text-properties (match-beginning 0)
									   (point-at-eol)
									   '(face (:foreground "#6b6665")))))))
  (advice-add 'save-buffers-kill-terminal :before 'org-save-all-org-buffers)
  (advice-add 'org-agenda-quit :before 'org-save-all-org-buffers)
  (defvar org-agenda-window-setup 'current-window)
  (defvar org-agenda-span 7)
  (setq org-agenda-files '("~/.emacs.d/org/todos.org"))
  (defvar org-agenda-skip-scheduled-if-done t)
  (defvar org-agenda-skip-deadline-if-done t)
  (defvar org-agenda-skip-deadline-prewarning-if-scheduled t)
  (defvar org-agenda-start-on-weekday nil)
  (defvar org-agenda-sorting-strategy
	'((agenda scheduled-up habit-down priority-down category-keep)
	  (todo priority-down category-up)
	  (tags priority-down category-keep)
	  (search category-keep)))
  (defvar org-agenda-skip-scheduled-if-done t)
  (setq org-log-done t)
  (setq org-enforce-todo-dependencies t)
  (define-key org-mode-map (kbd "<C-tab>") 'save-buffer))

(use-package helm
  :bind (("C-<" . helm-recentf);; Recientes
	 ("C-z" . helm-find-files);; C-z ahora sirve para abrir un archivo
	 ("C-b" . helm-buffers-list);; Buffers abiertos
	 ("M-x" . helm-M-x));; Ejecuta un comando
  :config
  (setq helm-split-window-in-side-p t)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action); normal tab
  (define-key helm-map (kbd "<C-tab>") 'helm-select-action)
  (defvar helm-ff-newfile-prompt-p nil))

(use-package minimap
  :bind ("C-c m" . minimap-mode))

(use-package nodejs-repl
  :bind ("C-c o" . nodejs-repl))

(use-package magit
  :bind ("C-," . magit-status))

(use-package irony
  :mode ("\\.c\\'" "\\.cpp\\'" "\\.cc\\'")
  :config
  (define-key irony-mode-map [remap completion-at-point]
	'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
	'irony-completion-at-point-async)
  (irony-cdb-autosetup-compile-options))

(provide 'packages)
;;; packages.el ends here
