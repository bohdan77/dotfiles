(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar packages '(evil autopair avy evil-surround key-chord zenburn-theme smooth-scrolling helm evil-leader smartparens aggressive-indent company company-c-headers projectile helm-projectile flycheck flycheck-tip rainbow-mode discover-my-major rainbow-delimiters mode-icons rich-minority powerline powerline-evil js2-mode web-mode company-web company-statistics anaconda-mode company-anaconda cmake-font-lock cmake-mode company-quickhelp evil-nerd-commenter rtags ) "Packages")

(defun packages-installed ()
  (cl-loop for pkg in packages
           when (not (package-installed-p pkg)) do (cl-return nil)
           finally (return t)))
(unless (packages-installed)
  (message "%s" "Refreshing package database")
  (package-refresh-contents)
  (dolist (pkg packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;;
;;
;;
;;
;;

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

;;file backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

(setq tab-width 4
      indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "RET") 'newline-and-indent)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)

(show-paren-mode t)

(require 'autopair)
(evil-mode 1)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(key-chord-mode 1)
(key-chord-define evil-insert-state-map "fd" 'evil-normal-state)

(global-evil-surround-mode 1)

(define-key evil-normal-state-map (kbd "C-z") 'avy-goto-char-2)

(push '(font . "Source Code Pro-14") default-frame-alist)

(smooth-scrolling-mode 1)

(require 'helm)
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-X C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)
(setq helm-M-x-fuzzy-match t) 
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(global-evil-leader-mode)


(defun switch-to-previous-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(evil-leader/set-key
  "f" 'helm-find-files
  "k" 'kill-buffer
  "b" 'helm-buffers-list
  "a" 'switch-to-previous-buffer
  "z" 'avy-goto-char
  "d" 'helm-semantic-or-imenu
  "m" 'helm-man-woman
  "p" 'helm-projectile
  "x" 'er/expand-region
  ";" 'evilnc-comment-or-uncomment-lines
  )
(require 'tern)
(evil-leader/set-key-for-mode
  'python-mode
  "e" 'anaconda-mode-find-definitions
  "q" 'anaconda-mode-show-doc
  "w" 'anaconda-mode-find-references
  "r" 'anaconda-mode-go-back
  ;; "yn" 

  )

(evil-leader/set-key-for-mode
  'c++-mode
  "e" 'rtags-find-symbol-at-point
  "w" 'rtags-find-references-at-point
  "r" 'rtags-location-stack-back
  "tv" 'rtags-find-virtuals-at-point
  "tf" 'rtags-fixit
  "q" 'rtags-symbol-type
  "yn" 'rtags-rename-symbol
  "tq" 'rtags-include-file
  "tw" 'rtags-get-include-file-for-symbol
  
  )

(evil-leader/set-leader "<SPC>")

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(require 'smartparens-config)
(add-hook 'prog-mode-hook #'smartparens-mode)

(add-hook 'prog-mode-hook #'aggressive-indent-mode)

(add-hook 'prog-mode-hook 'semantic-mode)
(require 'cmake-mode)

(add-hook 'cmake-mode-hook 'cmake-font-lock-activate)

(add-hook 'prog-mode-hook 'turn-on-eldoc-mode)



(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-c-headers)
     ))

(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<return>") nil)
     ))

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

(setq company-idle-delay 0)

(setq company-tooltip-limit 20)   

(setq company-tooltip-align-annotations 't)   

(require 'company-web-html)
(add-hook 'after-init-hook 'company-statistics-mode)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(projectile-global-mode)

(add-hook 'prog-mode-hook 'rainbow-mode)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(global-flycheck-mode)
(require 'flycheck-tip)
;; To avoid echoing error message on minibuffer (optional)
(setq flycheck-display-errors-function 'ignore)

(mode-icons-mode)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))

(company-quickhelp-mode 1)

(setq rtags-path "/home/bohdan/rtags/bin")

(require 'company-rtags)
(push 'company-rtags company-backends)

(setq rtags-autostart-diagnostics t)
(setq rtags-completions-enabled t)
(require 'flycheck-rtags)
(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
;; c-mode-common-hook is also called by c++-mode
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)
(require 'rtags-helm)
(setq rtags-use-helm t)

(add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-common-hook 'rtags-start-process-unless-running)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(custom-enabled-themes (quote (zenburn-theme)))
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "4e753673a37c71b07e3026be75dc6af3efbac5ce335f3707b7d6a110ecb636a3" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default)))
 '(fci-rule-color "#383838")
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages (quote (evil)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'powerline)
(require 'powerline-evil)
(powerline-evil-vim-theme)
(load-theme 'zenburn t)
