;;; base.el --- Base config for Emacs
;;; Author: Ali Ghahraei Figueroa
;;; Commentary:
;;; Code:

(tool-bar-mode -1)

(menu-bar-mode -1); Desactiva el menú

(setq inhibit-startup-message t); Adiós a la pantalla de inicio

(setq custom-safe-themes t); Desactiva la verificación de tema

(electric-pair-mode 1); Que la inserción de paréntesis comience

(defalias 'yes-or-no-p 'y-or-n-p); Un sucio truco para que el prompt sea solo y/n

(setq browse-url-browser-function 'browse-url-generic)
(defvar browse-url-generic-program "chromium"); chrome default

(global-set-key (kbd "C-x k") 'kill-this-buffer); Mata a ESTE buffer
(global-set-key (kbd "C-x M-k") 'kill-buffer); Mata a un buffer

(set-face-attribute 'default nil :height 130); Cambia la fuente

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))); Respaldo

(global-set-key (kbd "<wheel-right>") (lambda () (interactive)))
(global-set-key (kbd "<mouse-6>") (lambda () (interactive)))
(global-set-key (kbd "<wheel-left>") (lambda () (interactive))); Arregla el error del scrolleo

(global-set-key (kbd "<C-tab>") (lambda ()
								  (interactive)
								  (whitespace-cleanup)
								  (save-buffer))); Nueva combinación para guardar

(global-set-key (kbd "C-c C-M-b") 'backward-char); Mueve el cursor hacia atrás

(delete-selection-mode 1); Que el texto seleccionado pueda borrarse

(setq-default tab-width 4)
(add-hook 'prog-mode-hook (lambda ()
							(defvar c-basic-offset 4)
							(setq tab-width 4)))

(defadvice save-buffers-kill-emacs (around no-y-or-n activate)
  "Allow Emacs to close even if there are unsaved buffers."
  (cl-flet ((yes-or-no-p (&rest args) t)
		 (y-or-n-p (&rest args) t))
	ad-do-it))

(setq visible-bell 1); Adios al beep

(global-auto-revert-mode t); Reload files when changed


(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))) ;; two lines at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(defun rename-file-and-buffer ()
  "Rename the current buffer and the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
	(if (not (and filename (file-exists-p filename)))
		(message "Buffer is not visiting a file!")
	  (let ((new-name (read-file-name "New name: " filename)))
		(cond
		 ((vc-backend filename) (vc-rename-file filename new-name))
		 (t
		  (rename-file filename new-name t)
		  (set-visited-file-name new-name t t)))))))

(setq initial-scratch-message (format ";; LISP, motherfucker, do you speak it?\n"))

(setq vc-follow-symlinks t)

(desktop-save-mode 1)

;;; base.el ends here
