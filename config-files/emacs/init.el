;;; init.el --- Configuration file for Emacs.
;;; Author: Ali Ghahraei Figueroa
;;; Commentary:
;;; Code:

; (package-initialize)
(setq package-enable-at-startup nil)

(add-to-list 'load-path "~/.emacs.d/config/")
(load-library "base")
(load-library "packages")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-hide-fringes t)
 '(package-selected-packages
   (quote
	(yaml-mode kaolin-themes kaolin-theme elixir-mode aggressive-indent company-web web-mode tide company racer rust-playground jedi multi-term irony magit nodejs-repl neotree minimap circe helm haskell-mode scala-mode realgud flycheck rainbow-delimiters gruvbox-theme smart-mode-line-powerline-theme smart-mode-line projectile req-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-active-region-background ((t (:background "dark violet")))))


(provide 'init)
;;; init.el ends here
