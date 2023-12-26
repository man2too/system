(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'package)

(package-initialize)
(package-refresh-contents)
 
;;keybindings
(global-set-key (kbd "C-;") #'eshell)
(global-set-key (kbd "C-c c") #'compile)
(global-set-key "\C-x\ \C-g" 'recentf-open-files)

(global-visual-line-mode 1)

(fringe-mode 1)   ;;don't think this is working
(global-subword-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)

    
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)



;; Fix eshell overwriting history.
;; From https://emacs.stackexchange.com/a/18569/15023.
(setq eshell-save-history-on-exit nil)
(defun eshell-append-history ()
  "Call `eshell-write-history' with the `append' parameter set to `t'."
  (when eshell-history-ring
    (let ((newest-cmd-ring (make-ring 1)))
      (ring-insert newest-cmd-ring (car (ring-elements eshell-history-ring)))
      (let ((eshell-history-ring newest-cmd-ring))
        (eshell-write-history eshell-history-file-name t)))))
(add-hook 'eshell-pre-command-hook #'eshell-append-history)
(add-hook 'eshell-mode-hook #'(lambda () (setq eshell-exit-hook nil)))

(use-package em-hist
  :ensure nil
  :config
  (setq
   eshell-hist-ignoredups t
   ;; Set the history file.
   eshell-history-file-name "~/.bash_history"
   ;; If nil, use HISTSIZE as the history size.
   eshell-history-size 10000
   )
  )


(defun face-picker ()
 (interactive)
 (describe-face (face-at-point)))

(global-set-key (kbd "C-c f" ) 'face-picker)



(setq redisplay-dont-pause t
      scroll-margin 5 
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1
      inhibit-startup-screen t
      default-frame-alist '((font . "SF Mono-15"))
      )

(setq make-backup-files nil)
(setq auto-save-default nil)

;;(setq no-littering-etc-directory
;;      (expand-file-name "config/" user-emacs-directory))
;;(require 'no-littering)



(use-package lsp-mode
  :ensure t
  :hook (c++-mode . lsp))
       ;; (python-mode . lsp)
       ;; (rust-mode . lsp)

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :custom
  (lsp-ui-doc-show-with-cursor t))



;;Company - text completion framework
(use-package company
  :ensure t
  :init (global-company-mode)
  :bind (:map company-active-map
	      ("<tab>" . company-select-next)
	      ("<backtab>" . company-select-previous))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.01))  
  (setq company-global-modes'(not eshell-mode))


(use-package flycheck
  :ensure
  :init (global-flycheck-mode))

;; Example configuration for Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)    
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window) 
         ("C-x 5 b" . consult-buffer-other-frame)  
         ("C-x r b" . consult-bookmark)            
         ("C-x p b" . consult-project-buffer)      
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)               
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               
         ("M-g g" . consult-goto-line)           
         ("M-g M-g" . consult-goto-line)           
         ("M-g o" . consult-outline)              
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)        
         ("M-s e" . consult-isearch-history)       
         ("M-s l" . consult-line)                 
         ("M-s L" . consult-line-multi)           
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 
         ("M-r" . consult-history))                
)
  ;; Enable vertico
  (use-package vertico
    :ensure t
    :init
    (vertico-mode)

    
    )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)


  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)


  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :ensure t
  :init

  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("d23073a9616156a16aecbd3d38e1c3a1f006fc5d920e3fbcb681411e35d2a096" "3454885b915a176dce4b53e35053b7ee0aa9362fb9e934057ac44b6842a97453" "7c7026a406042e060bce2b56c77d715c3a4e608c31579d336cb825b09e60e827" "fa7caecc85dd0aaf60d4f74e42300a1a69f32efbad61fbd3ca26d0dcf6dfedd5" "a77735fe0193d57476298d982de95c51f1625da7aa4a07473be8143cf3326dc2" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" "ba4ab079778624e2eadbdc5d9345e6ada531dc3febeb24d257e6d31d5ed02577" "c7eb06356fd16a1f552cfc40d900fe7326ae17ae7578f0ef5ba1edd4fdd09e58" "36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "a15bf10d72178d691b09c4bbf6d24b15c156fbae9e6fdbaf9aa5e1d9b4c27ca6" "23b564cfb74d784c73167d7de1b9a067bcca00719f81e46d09ee71a12ef7ee82" "1cd4df5762b3041a09609b5fb85933bb3ae71f298c37ba9e14804737e867faf3" "ff4d091b20e9e6cb43954e4eeae1c3b334e28b5923747c7bd5d2720f2a67e272" "b6341db18cc3f1991de8c4f58b6ec500b4518256af97b0183ec5e01ad72ae620" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "73b6fb50100174334d220498186ab5ca3ade90052f5a08e8262e5d7820f0a149" "ba913d12adb68e9dadf1f43e6afa8e46c4822bb96a289d5bf1204344064f041e" "773e0bfa5450c75d613cbf29734cdc876c3d59dbf85b93cff3015a8687dea158" "00a9bb90413c4e218f02287db09e5dae9f6080890dd641ec0d6ff83d28d1335f" "d1b46cf4414713c0901c3d77b640d857614b220e56c23f00c2fcfe5a2406b05a" "70f5a47eb08fe7a4ccb88e2550d377ce085fedce81cf30c56e3077f95a2909f2" "c3e6b52caa77cb09c049d3c973798bc64b5c43cc437d449eacf35b3e776bf85c" "5a0eee1070a4fc64268f008a4c7abfda32d912118e080e18c3c865ef864d1bea" "3860a842e0bf585df9e5785e06d600a86e8b605e5cc0b74320dfe667bcbe816c" "f56e81765ccd0ee403860bd1d0a2f9967aa132b4a6f40517dd5eb13f7726eaba" "b6a32f5bbe3c636432bdaa0bb7a5e24f7419cb1787135cc6295ac07d2fac628a" "f6a0635dce942dc3101fb3e29198af99ee9341caac22e9c0f739b77ac50f315b" "f87f74ecd2ff6dc433fb4af4e76d19342ea4c50e4cd6c265b712083609c9b567" "832b53660ed5ddfdc3944f4b8880761addd0b1cf90603772f540ef1695cf82f2" "bddf21b7face8adffc42c32a8223c3cc83b5c1bbd4ce49a5743ce528ca4da2b6" "b66970f42d765a40fdb2b6b86dd2ab6289bed518cf4d8973919e5f24f0ca537b" "3d4df186126c347e002c8366d32016948068d2e9198c496093a96775cc3b3eaa" "0cd00c17f9c1f408343ac77237efca1e4e335b84406e05221126a6ee7da28971" "0ac7d13bc30eac2f92bbc3008294dafb5ba5167f2bf25c0a013f29f62763b996" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" default))
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(catppuccin-theme ef-themes nordic-night-theme nyx-theme alect-themes tao-theme dakrone-light-theme constant-theme chocolate-theme grandshell-theme apropospriate-theme ancient-one-dark-theme timu-spacegrey-theme greymatters-theme grey-paper-theme arjen-grey-theme no-littering cyberpunk-theme abyss-theme darkokai-theme dark-krystal-theme adwaita-dark-theme spacemacs-theme atom-one-dark-theme flycheck :company company orderless vertico consult use-package lsp-ui lsp-mode))
 '(recentf-mode t)
 '(scroll-bar-mode nil)
 '(tab-bar-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#101010" :foreground "#e4e4ef" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 167 :width normal :foundry "DAMA" :family "Ubuntu Mono"))))
 '(cursor ((t (:background "gainsboro"))))
 '(error ((t (:foreground "indian red" :weight bold))))
 '(eshell-ls-archive ((t (:foreground "cornflower blue" :weight bold))))
 '(eshell-prompt ((t (:foreground "gainsboro" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "gainsboro"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "dark khaki"))))
 '(font-lock-comment-face ((t (:foreground "dark khaki"))))
 '(font-lock-keyword-face ((t (:foreground "snow" :weight bold))))
 '(fringe ((t (:background "#101010" :foreground "#101010"))))
 '(line-number ((t (:inherit default :background "#101010" :foreground "#45475a"))))
 '(line-number-current-line ((t (:inherit line-number :foreground "gainsboro"))))
 '(match ((t (:background "#6a89ad" :foreground "#181825"))))
 '(menu ((t (:background "#101010" :foreground "#cdd6f4" :inverse-video nil))))
 '(tab-bar-tab ((t (:foreground "gainsboro" :weight bold)))))
;;(add-to-list 'default-frame-alist '(background-color . "#0a0a0a"))
