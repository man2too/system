(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'package)

(package-initialize)
(package-refresh-contents)
 
(setq default-frame-alist '((font . "Ubuntu Mono-18")))                                   
(setq inhibit-startup-screen t)


(global-set-key (kbd "C-;") #'shell)
(global-set-key (kbd "C-c c") #'compile)
(global-set-key "\C-x\ \C-g" 'recentf-open-files)
(setq redisplay-dont-pause t
      scroll-margin 5 
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(setq make-backup-files nil)

(setq no-littering-etc-directory
      (expand-file-name "config/" user-emacs-directory))
(require 'no-littering)



(use-package lsp-mode
  :ensure t
  :hook (c++-mode . lsp))

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
 '(custom-enabled-themes '(timu-spacegrey light-blue))
 '(custom-safe-themes
   '("c7eb06356fd16a1f552cfc40d900fe7326ae17ae7578f0ef5ba1edd4fdd09e58" "36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "a15bf10d72178d691b09c4bbf6d24b15c156fbae9e6fdbaf9aa5e1d9b4c27ca6" "23b564cfb74d784c73167d7de1b9a067bcca00719f81e46d09ee71a12ef7ee82" "1cd4df5762b3041a09609b5fb85933bb3ae71f298c37ba9e14804737e867faf3" "ff4d091b20e9e6cb43954e4eeae1c3b334e28b5923747c7bd5d2720f2a67e272" "b6341db18cc3f1991de8c4f58b6ec500b4518256af97b0183ec5e01ad72ae620" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "73b6fb50100174334d220498186ab5ca3ade90052f5a08e8262e5d7820f0a149" "ba913d12adb68e9dadf1f43e6afa8e46c4822bb96a289d5bf1204344064f041e" "773e0bfa5450c75d613cbf29734cdc876c3d59dbf85b93cff3015a8687dea158" "00a9bb90413c4e218f02287db09e5dae9f6080890dd641ec0d6ff83d28d1335f" "d1b46cf4414713c0901c3d77b640d857614b220e56c23f00c2fcfe5a2406b05a" "70f5a47eb08fe7a4ccb88e2550d377ce085fedce81cf30c56e3077f95a2909f2" "c3e6b52caa77cb09c049d3c973798bc64b5c43cc437d449eacf35b3e776bf85c" "5a0eee1070a4fc64268f008a4c7abfda32d912118e080e18c3c865ef864d1bea" "3860a842e0bf585df9e5785e06d600a86e8b605e5cc0b74320dfe667bcbe816c" "f56e81765ccd0ee403860bd1d0a2f9967aa132b4a6f40517dd5eb13f7726eaba" "b6a32f5bbe3c636432bdaa0bb7a5e24f7419cb1787135cc6295ac07d2fac628a" "f6a0635dce942dc3101fb3e29198af99ee9341caac22e9c0f739b77ac50f315b" "f87f74ecd2ff6dc433fb4af4e76d19342ea4c50e4cd6c265b712083609c9b567" "832b53660ed5ddfdc3944f4b8880761addd0b1cf90603772f540ef1695cf82f2" "bddf21b7face8adffc42c32a8223c3cc83b5c1bbd4ce49a5743ce528ca4da2b6" "b66970f42d765a40fdb2b6b86dd2ab6289bed518cf4d8973919e5f24f0ca537b" "3d4df186126c347e002c8366d32016948068d2e9198c496093a96775cc3b3eaa" "0cd00c17f9c1f408343ac77237efca1e4e335b84406e05221126a6ee7da28971" "0ac7d13bc30eac2f92bbc3008294dafb5ba5167f2bf25c0a013f29f62763b996" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" default))
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(dakrone-light-theme constant-theme chocolate-theme grandshell-theme apropospriate-theme ancient-one-dark-theme timu-spacegrey-theme greymatters-theme grey-paper-theme arjen-grey-theme no-littering cyberpunk-theme abyss-theme darkokai-theme dark-krystal-theme adwaita-dark-theme spacemacs-theme atom-one-dark-theme flycheck :company company orderless vertico consult use-package lsp-ui lsp-mode))
 '(recentf-mode t)
 '(scroll-bar-mode nil)
 '(tab-bar-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
