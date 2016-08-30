(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


(setq package-list '(ample-theme anaconda-mode auto-complete autopair avy cmake-font-lock cmake-ide cmake-mode company company-anaconda company-irony company-irony-c-headers company-tern company-web dash evil evil-args evil-avy evil-surround expand-region flycheck helm helm-projectile helm-swoop irony js2-mode key-chord magit magit-popup popup powerline projectile pythonic rainbow-delimiters rainbow-mode rtags smart-mode-line smartparens smooth-scrolling tern web-mode disable-mouse nlinum yasnippet  ))

 ;;fetch the list of packages available 
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;above installs packages

;;desktop save
(desktop-save-mode 1)
;;disables startup splash/scratch
(setq inhibit-splash-screen t
      initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;;marking text
(delete-selection-mode t)

;;no tabs por favor
(setq tab-width 4
      indent-tabs-mode nil)

;;disable backup
(setq make-backup-files nil)

;;yes or no shortened
(defalias 'yes-or-no-p 'y-or-n-p)

;;less echo time, no dialog boxes or sounds
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

;;column number mode
(setq column-number-mode t)

;;kill temp files
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;;autopair
(require 'autopair)

;;ansi-color
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;;org mode logging
(setq org-log-done t)

;;font
(set-frame-font "Source Code Pro-14" nil)

					;helm
(require 'helm)
(require 'helm-config)
(require 'helm-projectile)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(setq helm-buffers-fuzzy-matching t)
(setq helm-M-x-fuzzy-match t)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action

;;evil
(evil-mode 1)
(global-evil-surround-mode 1)
(setq evil-insert-state-cursor '((bar . 1) "green")
      evil-normal-state-cursor '(box "#F5F5DC"))
(setq evil-find-skip-newlines t)
(setq evil-move-cursor-back t)

;;avy(quick jumping)
(evil-avy-mode 1)
;;(global-set-key (kbd "<SPC>") 'avy-goto-char)

;expand-region(only works in insert mode)
(define-key evil-insert-state-map (kbd "C-q") 'er/expand-region)
;;(key-chord-define-global

;;flycheck
(require 'flycheck)

(require 'rtags)
;(require 'flycheck-rtags)
(global-flycheck-mode 1)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)

(setq-default flycheck-disabled-checkers
	      (append flycheck-disabled-checkers
		      '(c/c++-clang)))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)

(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
;; c-mode-common-hook is also called by c++-mode
;(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

;;smooth scrolling
(smooth-scrolling-mode 1)

;;rainbow braces
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;projectile
(projectile-global-mode)
(helm-projectile-on)

;line numbers
(global-nlinum-mode 1)


;;smartparens
(require 'smartparens-config)
(add-hook 'js2-mode-hook #'smartparens-mode)
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'web-mode-hook #'smartparens-mode)
(add-hook 'c++-mode-hook #'smartparens-mode)
(add-hook 'cmake-mode-hook #'smartparens-mode)

					;magit
(defun magit-hook ()
  (global-set-key (kbd "C-x g") ’magit-status)
  (global-set-key (kbd "C-x M-g") ’magit-dispatch-popup)
)
(add-hook 'after-init-hook 'magit-hook)

(defun delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

;;company-mode
(add-hook 'after-init-hook 'global-company-mode)
(setq company-tooltip-limit 20)
(setq company-tooltip-align-annotations 't)
(setq company-dabbrev-ignore-case 't)
(setq company-dabbrev-code-ignore-case 't)
(setq company-anaconda-case-insensitive 't)
(setq company-idle-delay .3)
(require 'company-web-html)   
(global-set-key (kbd "M-<tab>") 'company-complete) 

;;evil args(movement between function arguments)
(require 'evil-args)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;n; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)

;;python anaconda
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(eval-after-load "company"
'(add-to-list 'company-backends 'company-anaconda))

(add-hook 'python-mode-hook 'anaconda-mode)

;;window size
(when window-system (set-frame-size (selected-frame) 112 48))

;;web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jin\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))


(setq web-mode-engines-alist
      '(("jinja"    . "\\.jin\\'")
        ("blade"  . "\\.blade\\."))
)

;;js2 mode(javascript related)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;;javascript tern and company
(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))

;;switch to previous buffer
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer))))
					; Add cmake listfile names to the mode list.

				  
(setq auto-mode-alist
	  (append
	   '(("CMakeLists\\.txt\\'" . cmake-mode))
	   '(("\\.cmake\\'" . cmake-mode))
	   auto-mode-alist))


(cmake-ide-setup)

					;rainbow color mode
(add-hook 'css-mode-hook #'rainbow-mode)


;;C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

					;cmake
(autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
(add-hook 'cmake-mode-hook 'cmake-font-lock-activate)

;;rtags
;(setq rtags-completions-enabled t)
;(push 'company-rtags company-backends)
(rtags-enable-standard-keybindings)
(setq rtags-use-helm t)

;;irony
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(setq irony-additional-clang-options '("-std=c++11"))

(require 'company-irony-c-headers)
   ;; Load with `irony-mode` as a grouped backend
   (eval-after-load 'company
     '(add-to-list
       'company-backends '(company-irony-c-s company-irony)))

;;generic keybinds
(key-chord-mode 1)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key [C-backspace] 'delete-word)
(key-chord-define evil-normal-state-map "fd" 'evil-force-normal-state)
(key-chord-define evil-visual-state-map "fd" 'evil-change-to-previous-state)
(key-chord-define evil-insert-state-map "fd" 'evil-normal-state)
(key-chord-define evil-replace-state-map "fd" 'evil-normal-state)
(key-chord-define-global "JJ" 'switch-to-previous-buffer)
(global-set-key (kbd "C-x g") 'magit-status)

(load-theme 'ample-flat t)

;;make the fringe color the same
  (set-face-attribute 'fringe nil
                      :foreground (face-foreground 'default)
                      :background (face-background 'default))

;;remove modeline border
(set-face-attribute 'mode-line nil
                    :box nil)

;;change cursor
(setq-default cursor-type 'bar) 

;;modeline color

(set-face-foreground 'mode-line "#B9B9B9")
(set-face-background 'mode-line "#2F2F2F")


;;disable the mouse in emacs --only useful for laptops, I guess.
(add-hook 'prog-mode 'disable-mouse-mode)
(evil-make-overriding-map disable-mouse-mode-map)
