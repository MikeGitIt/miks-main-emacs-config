(setq sgt/config-file "~/DotFiles/Emacs.org")

(setq sgt/default-font-size 120)
(setq sgt/default-variable-font-size 125)
(setq sgt/mac nil)
(setq sgt/fixed-font-name "FiraCode Nerd Font")
(setq sgt/variable-font-name "FiraCode Nerd Font")
(setq sgt/variable-font-weight 'regular)
(setq sgt/variable-font-heading-weight 'regular)

(when (equal (system-name) "thelio")
  (setq sgt/default-font-size 110)
  (setq sgt/default-variable-font-size 120)
  (add-to-list 'exec-path "~/.opam/4.12.0/bin")
  (add-to-list 'exec-path "~/.cabal/bin"))

(when (or (string-suffix-p "public.utexas.edu" (system-name))
          (string-prefix-p "ilo-sona" (system-name)))
  (setq sgt/default-font-size 120)
  (setq sgt/default-variable-font-size 130)
  (setq sgt/variable-font-weight 'medium)
  (setq sgt/variable-font-heading-weight 'semibold)
  (setq sgt/mac t)
  (pixel-scroll-precision-mode)
  (add-to-list 'exec-path "/opt/homebrew/bin")
  (add-to-list 'exec-path "~/.cargo/bin")
  (add-to-list 'exec-path "~/.cabal/bin")
  (add-to-list 'exec-path "/Library/TeX/texbin"))


(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(electric-pair-mode 1)
(setq ident-tabs-mode nil)

(setq delete-old-versions -1)  ; delete excess backup versions silently
(setq version-control t)       ; use version control
(setq vc-make-backup-files t)  ; make backups file even when in version controlled dir
(setq backup-directory-alist   ; which directory to put backups file
      `(("." . "~/.emacs.d/backups")) )
(setq vc-follow-symlinks t)    ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms  ; transform backups file name
      '((".*" "~/.emacs.d/auto-save-list/" t)) ) 
(setq inhibit-startup-screen t) ; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore)       ; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8)    ; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)    ; sentence SHOULD end with only a point.
(setq default-fill-column 80)           ; toggle wrapping text at the 80th character
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Make ESC quit prompts
(setq scroll-step 1
      scroll-conservatively 101)
(global-hl-line-mode)
(setq comp-async-report-warnings-errors nil)
(setq warning-suppress-types '(comp))
(global-auto-revert-mode 1) ;; make all buffers revert on file changes
(setq indent-tabs-mode nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(straight-use-package 'omnisharp-mode)
(eval-after-load
  'company
  '(add-to-list 'company-backends #'company-omnisharp))

(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  (setq tab-width 4)
  (setq evil-shift-width 4)

  ;csharp-mode README.md recommends this too
  ;(electric-pair-mode 1)       ;; Emacs 24
  ;(electric-pair-local-mode 1) ;; Emacs 25

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)
;; set font
(set-face-attribute 'default nil
                    :font sgt/fixed-font-name
                    :height sgt/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil
                    :font sgt/fixed-font-name
                    :height sgt/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil
                    :font sgt/variable-font-name
                    :height sgt/default-variable-font-size
                    :weight sgt/variable-font-weight)

(use-package fira-code-mode
  ;; List of ligatures to turn off
  :custom (fira-code-mode-disabled-ligatures '("x" "[]" "<>"))
  :hook prog-mode)

(defun sgt/load-theme-light ()
  "Load a light theme"
  (interactive)
  (load-theme 'gruvbox-light-medium t))

(defun sgt/load-theme-dark ()
  "Load a dark theme"
  (interactive)
  (load-theme 'gruvbox-dark-medium t))

(use-package gruvbox-theme
  :config (load-theme 'gruvbox t))

(use-package all-the-icons)
(use-package doom-modeline
  :after eshell
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dashboard
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-items '((recents . 5)
                     (projects . 5)
                     (agenda . 5)))
  (initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

(use-package general)

(use-package selectrum
  :init (selectrum-mode)
  :general
  (:keymaps 'selectrum-minibuffer-map
   "C-j" 'selectrum-next-candidate
   "C-k" 'selectrum-previous-candidate))

(use-package orderless
  :custom (completion-styles '(orderless)))

(use-package consult
  :general
  (:states '(normal visual insert emacs)
           :prefix "SPC"
           :non-normal-prefix "C-SPC"
           :keymaps 'override
           
           ;; yank pop
           "yp" 'consult-yank-pop
           
                 ;; errors
           "El" 'consult-flymake))

(use-package marginalia
  :init (marginalia-mode))

(use-package all-the-icons)

(use-package all-the-icons-completion
  :init (all-the-icons-completion-marginalia-setup))

;; (use-package ivy
;;   :diminish
;;   :bind (:map ivy-minibuffer-map
;;            ("TAB" . ivy-alt-done) ; make ivy more vim friendly
;;            ("C-j" . ivy-next-line)
;;            ("C-k" . ivy-previous-line)
;;            ("C-h" . ivy-backward-delete-char)
;;            :map ivy-switch-buffer-map
;;            ("C-k" . ivy-previous-line)
;;            ("C-d" . ivy-switch-buffer-kill))
;;   :custom
;;   ((ivy-count-format "")
;;    (ivy-use-virtual-buffer t)
;;    (ivy-initial-inputs-alist nil))
;;   :config
;;   (ivy-mode 1))

;; (use-package all-the-icons-ivy-rich
;;   :init (all-the-icons-ivy-rich-mode 1))

;; (use-package ivy-rich
;;   :diminish
;;   :after (ivy)
;;   :config
;;   (ivy-rich-mode 1))

;; (use-package counsel)

;; (use-package swiper)

;; (use-package ivy-prescient
;;   :config
;;   (ivy-prescient-mode))

(use-package helpful
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"
           
           "d" '(:ignore t :wk "Describe")
           "d." 'helpful-symbol
           "df" 'helpful-function
           "dv" 'helpful-variable
           "dk" 'helpful-key
           "dc" 'helpful-command)
  :config
  (defvar read-symbol-positions-list nil))

;; use which-key package so that keybindings are easier to rememeber
(use-package which-key
  :config (which-key-mode))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :custom
  (evil-want-C-i-jump nil)
  :config (evil-mode 0) ;; activate evil mode

  ;; set the colors of the cursor
  (setq evil-emacs-state-cursor '("#fb4933" box)) 
  (setq evil-normal-state-cursor '("#fabd2f" box))
  (setq evil-visual-state-cursor '("#83a598" box))
  (setq evil-insert-state-cursor '("#b8bb26" bar))
  (setq evil-replace-state-cursor '("#fb4933" box))
  (setq evil-operator-state-cursor '("#d3869b" hollow))

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-calendar-want-org-bindings t)
  (evil-collection-setup-minibuffer nil)
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  ;; remap visual surround to use lower-case "s" rather than "S"
  (general-define-key
   :states 'visual
   "s" 'evil-surround-region)
  ;; make the mode active everywhere
  (global-evil-surround-mode 1))

(use-package origami
  :ensure t
  :config
  (global-origami-mode))

(general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   :keymaps 'override
   
   ;; Buffers
   "b" '(:ignore t :which-key "Buffer")
   "bb" 'consult-buffer
   "bp" 'previous-buffer
   "bn" 'next-buffer
   "bd" 'evil-delete-buffer
   "br" 'revert-buffer)

(general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   :keymaps 'override

   ;; Windows
   "w" '(:ignore t :which-key "Windows")
   "ws" 'ace-select-window
   "w-" 'split-window-below
   "w/" 'split-window-right
   "wd" 'delete-window
   "wh" 'windmove-left
   "wH" 'evil-window-move-far-left
   "wj" 'windmove-down
   "wJ" 'evil-window-move-very-bottom
   "wk" 'windmove-up
   "wK" 'evil-window-move-very-top
   "wl" 'windmove-right
   "wL" 'evil-window-move-far-right)

(general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   :keymaps 'override

   "SPC" 'execute-extended-command
   ;; "/" 'swiper-all
   "ss" 'consult-line
   ;; "i" 'counsel-semantic-or-imenu
   "i" 'consult-imenu
   "'" 'eshell
   "!" 'shell-command
   "&" 'async-shell-command

   ;; quitting
   "q" '(:ignore t :which-key "Quit")
   "qq" 'save-buffers-kill-emacs

   ;; Files
   "f" '(:ignore t :which-key "Files")
   "ff" 'find-file

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ar" 'ranger
   "av" 'multi-vterm

   ;; Config
   "ec" '(:ignore t :which-key "Config")
   "ece" '(sgt/open-config :which-key "Edit Config")
   "ecr" '(sgt/reload-config :wk "Reload Config")

   ;; Compile
   "c" '(:ignore t :whick-key "Compile")
   "cc" 'compile
   "cr" 'recompile

   ;; Dired
   "dj" 'dired-jump

   ;; toggles
   "t" '(:ignore t :which-key "Toggles")
   "tn" 'display-line-numbers-mode
   "te" 'electric-pair-mode

   ;; Themes
   "T" '(:ignore t :which-key "Themes")
   "Tl" '(sgt/load-theme-light :which-key "Light")
   "Td" '(sgt/load-theme-dark :which-key "Dark")
   "Tc" '(load-theme :which-key "Custom"))

(use-package undo-tree
  :custom
  (undo-tree-auto-save-history nil)
  :init
  (global-undo-tree-mode 1))

(use-package ranger
  :custom
  (;; (ranger-override-dired mode t)
   (ranger-cleanup-on-disable t)
   (ranger-dont-show-binary t)))

(use-package flycheck)

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-," . embark-act-all)
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package evil-goggles
  :custom
  (evil-goggles-duration 0.100)
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package eldoc
  :custom
  (eldoc-echo-area-use-multiline-p nil))

(use-package popper
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"
           "`" 'popper-toggle-latest
           "~" 'popper-cycle)
  :custom
  (popper-reference-buffers '("\\*Messages\\*"
                              "Output\\*$"
                              "\\*Async Shell Command\\*"
                              help-mode
                              compilation-mode
                              eldoc-mode))
  (popper-window-height 30)
  :init
  (popper-mode +1)
  (popper-echo-mode +1))

(use-package avy
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"
           "j" '(:ignore t :which-key "Jump (avy)")
           "jj" 'avy-goto-char-timer))

(use-package compile
  :straight nil
  :custom
  (compilation-scroll-output t))

(use-package evil-nerd-commenter
  :after (evil evil-collection)
  :general
  (:states '(normal visual)
           "gc" 'evilnc-comment-operator))

(use-package corfu
  :straight t
  :general
  (:keymap 'corfu-map
            :states '(insert normal emacs)
            "C-j" 'corfu-next
            "C-k" 'corfu-previous
            "M-d" 'corfu-show-documentation)

  :custom
  (corfu-auto t)
  (corfu-echo-documentation t)
  (corfu-cycle t)
  (lsp-completion-provider :none)

  :init (global-corfu-mode))

(use-package corfu-doc
  :straight (corfu-doc :type git :host github :repo "galeo/corfu-doc")
  :after corfu
  :general (:keymaps 'corfu-map
                     ;; This is a manual toggle for the documentation window.
                     [remap corfu-show-documentation] #'corfu-doc-toggle
                     ;; Scroll in the documentation window
                     "M-j" #'corfu-doc-scroll-up
                     "M-k" #'corfu-doc-scroll-down)
  :custom
  (corfu-doc-delay 0.5)
  (corfu-doc-max-width 70)
  (corfu-doc-max-height 20)
  (corfu-echo-documentation t)
  :config
  (corfu-doc-mode))

(use-package projectile
  :disabled
  :diminish projectile-mode
  :config (projectile-mode)
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   "p" '(:ignore t :which-key "Projects")
   "pf" 'project-find-file
   ;; "pa" 'projectile-add-known-project
   ;; "pb" 'counsel-projectile-switch-to-buffer
   "pb" 'consult-project-buffer
   ;; "pc" 'counsel-compile
   "pp" 'project-switch-project
   "pt" 'treemacs
   ;; "p/" 'counsel-projectile-ag
   "p'" 'projectile-run-vterm)
  ;; :custom ((projectile-completion-system 'ivy))
  )

;; (use-package counsel-projectile
;;   :commands (magit-status magit-blame)
;;   :config (counsel-projectile-mode))

(use-package project
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   "p" '(:ignore t :which-key "Projects")
   "pf" 'project-find-file
   "pb" 'consult-project-buffer
   "pp" 'project-switch-project
   "p'" 'project-eshell
   "pc" 'project-compile
   "p!" 'project-shell-command
   "p&" 'project-async-shell-command))

(defun sgt/project-try-cargo-toml (dir)
  "Try to locate a Rust project."
  (let ((found (locate-dominating-file dir "Cargo.toml")))
     (if (stringp found)`(transient . ,found) nil)))

;; Try rust projects before version-control (vc) projects
(add-hook 'project-find-functions 'sgt/project-try-cargo-toml nil nil)

(use-package treemacs
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   t
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-width                           35
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))

  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   ) 
                                        ; :bind
                                        ; (:map global-map
                                        ;       ("M-0"       . treemacs-select-window)
                                        ;       ("C-x t 1"   . treemacs-delete-other-windows)
                                        ;       ("C-x t t"   . treemacs)
                                        ;       ("C-x t B"   . treemacs-bookmark)
                                        ;       ("C-x t C-t" . treemacs-find-file)
                                        ;       ("C-x t M-t" . treemacs-find-tag))
  )

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"

           "g" '(:ignore t :which-key "Git")
           "gs" 'magit-status
           "gb" 'magit-blame
           "gc" 'magit-clone
           "gi" 'magit-init)
  (:keymaps 'with-editor-mode-map
            :states '(normal visual)
            :prefix ","

            "c" 'with-editor-finish
            "k" 'with-editor-cancel)
  ;; :config (general-define-key)
  )

(use-package git-timemachine
  :commands (git-timemachine)
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"
           "gT" 'git-timemachine))

(use-package vterm
  :commands (vterm))

(use-package multi-vterm
  :commands (multi-vterm)
  :general
  (:keymaps 'vterm-mode-map
            "C-h" 'vterm-send-C-h
            "RET" 'vterm-send-return
            ))

(use-package rg
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"

           "sp" 'rg-project))

(use-package yasnippet
  :config
  (add-to-list 'yas-snippet-dirs (locate-user-emacs-file "snippets"))
  (yas-global-mode +1))

(use-package lsp-mode
  :disabled
  :commands (lsp lsp-deferred)
  :config
  (lsp-enable-which-key-integration t)
  (company-mode -1)
  (general-define-key
   :states '(normal visual)
   :keymaps 'lsp-mode-map
   :prefix ","

   "a" '(:ignore t :which-key "Actions")
   "aa" 'lsp-execute-code-action

   "g" '(:ignore t :which-key "Jump")
   "gg" 'lsp-find-definition
   "gr" 'lsp-find-references
   "gt" 'lsp-find-type-definition

   "rr" 'lsp-rename))

(use-package lsp-ui
  :disabled
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'top)
  (lsp-ui-sideline-delay 1) ; don't show sideline immediately
  (lsp-ui-doc-use-webkit t)
  (lsp-ui-doc-delay 0)
  (lsp-ui-doc-enable nil)
  :general
  (:states 'normal
           :keymaps 'lsp-mode-map
           :prefix ","
           ;; "hd" 'lsp-ui-doc-glance
           "hh" 'lsp-ui-doc-show
           "hc" 'lsp-ui-doc-hide
           "ud" 'lsp-ui-imenu))

(use-package lsp-treemacs
  :disabled
  :after lsp
  :config
  (general-define-key
   :states '(normal visual)
   :keymaps 'lsp-command-map
   :prefix ","
   "el" 'lsp-treemacs-errors-list)
  ;; :general
  ;; (:keymaps '(lsp-mode-map)
  ;;        :states '(normal visual)
  ;;        :prefix ","
  ;;        "el" 'lsp-treemacs-errors-list)
  )

(use-package eglot
  :hook
  ((rust-mode . eglot-ensure)
   (python-mode . eglot-ensure))
  :general
  (general-define-key
   :states '(normal visual)
   :keymaps 'eglot-mode-map
   :prefix ","

   "a" '(:ignore t :which-key "Actions")
   "aa" 'eglot-code-actions

   "rr" 'eglot-rename))

(use-package web-mode
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|jsx\\)\\'")

(use-package rainbow-mode)

(defun cargo-process-build-release ()
  "Run the Cargo build command in release mode"
  (interactive)
  (cargo-process--start "Release" "build --release"))

(use-package rust-mode
  :mode "\\.rs\\'"
  :custom (rust-format-on-save t)
  :config
  (general-define-key
   :states '(normal visual)
   :keymaps 'rust-mode-map
   :prefix ","

   "c" '(:ignore t :which-key "Cargo")
   "cb" 'cargo-process-build
   "cB" 'cargo-process-build-release
   "cr" 'cargo-process-run
   "ca" 'cargo-process-add))

(use-package cargo
  :defer t)

(use-package racket-mode
  :general
  (:keymaps 'racket-mode-map
            :states '(normal visual)
            :prefix ","
            "x" 'racket-xp-mode
            "d" 'racket-xp-describe

            "r" '(:ignore t :wk "Repl")
            "rr" 'racket-repl
            "rf" '(racket-run :wk "Load file")

            "e" '(:ignore t :wk "Eval")
            "er" 'racket-send-region
            "ed" 'racket-send-definition
            "el" 'racket-send-last-sexp))

(general-define-key
 :states '(normal visual)
 :keymaps '(lisp-interaction-mode-map emacs-lisp-mode-map)
 :prefix ","

 "e" '(:ignore t :wk "Eval")
 "er" 'eval-region
 "eb" 'eval-buffer
 "el" 'eval-last-sexp
 "ef" 'eval-defun
 "ee" 'eval-print-last-sexp)

(use-package lispy)
(use-package evil-lispy)

;; (load-file (let ((coding-system-for-read 'utf-8))
;;              (shell-command-to-string "agda-mode locate")))

(use-package json-mode
  :hook (json-mode . flycheck-mode)
  :config
  (setq-local js-indent-level 2))

(use-package python
  :general
  (:states '(normal visual)
           :keymaps 'python-mode-map
           :prefix ","

           "rr" 'run-python))

(use-package souffle-mode
  :straight (souffle-mode :type git :host github :repo "souffle-lang/souffle-mode"))

(use-package csv-mode)

(use-package yaml-mode)

(use-package caddyfile-mode
  :ensure t
  :mode (("Caddyfile\\'" . caddyfile-mode)
         ("caddy\\.conf\\'" . caddyfile-mode)))

(use-package lean4-mode
  :straight (lean4-mode :type git :host github :repo "leanprover/lean4-mode")
  ;; to defer loading the package until required
  :commands (lean4-mode))

(use-package boogie-friends
  :config
  (setq flycheck-dafny-executable "dafny"))

;; (use-package ec2
;;   :straight (ec2 :type git :host github :repo "sgpthomas/ec2.el")
;;   :general
;;   (:states '(normal visual emacs)
;;            :prefix "SPC"
;;            "ad" 'ec2/dashboard))

(use-package org-latex-environment-mode
  :straight (org-latex-environment-mode
             :type git
             :host github
             :repo "sgpthomas/org-latex-environment-mode")
  :hook (org-mode . org-latex-environment-mode))

(require 'dash)
(require 's)

(defmacro with-face (STR &rest PROPS)
  "Return STR propertized with PROPS."
  `(propertize ,STR 'face (list ,@PROPS)))

(defmacro esh-section (NAME ICON FORM &rest PROPS)
  "Build eshell section NAME with ICON prepended to evaled FORM with PROPS."
  `(setq ,NAME
         (lambda () (when ,FORM
                      (concat ,ICON
                              (-> (concat esh-section-delim ,FORM)
                                  (with-face ,@PROPS)
                                  ))))))

(defun esh-acc (acc x)
  "Accumulator for evaluating and concatenating esh-sections."
  (--if-let (funcall x)
      (if (s-blank? acc)
          it
        (concat acc esh-sep it))
    acc))

(defun esh-prompt-func ()
  "Build `eshell-prompt-function'"
  (concat esh-header
          (-reduce-from 'esh-acc "" eshell-funcs)
          "\n"
          eshell-prompt-string))

;; Separator between esh-sections
(setq esh-sep "  ")  ; or " | "

;; Separator between an esh-section icon and form
(setq esh-section-delim " ")

;; Eshell prompt header
(setq esh-header "\n ")  ; or "\n┌─"

;; Eshell prompt regexp and string. Unless you are varying the prompt by eg.
;; your login, these can be the same.
(setq eshell-prompt-regexp " λ ")   ; or "└─> "
(setq eshell-prompt-string " λ ")   ; or "└─> "

(require 'magit)
(esh-section esh-dir
             (propertize (all-the-icons-faicon "folder-open")
                         'face `(:foreground "#83a598"
                                             :family ,(all-the-icons-faicon-family)
                                             :height 1.2))
             (abbreviate-file-name (eshell/pwd))
             '(:foreground "#83a598" :weight ultra-bold :underline t))

(esh-section esh-git
             (propertize (all-the-icons-octicon "repo")
                         'face `(:foreground "pink"
                                             :family ,(all-the-icons-octicon-family)
                                             :height 1.2))
             ;; "\xe907"  ;  (git icon)
                   (if (fboundp 'magit-get-current-branch)
                       (magit-get-current-branch)
                     "")
             
             '(:foreground "pink"))

(esh-section esh-clock
             (propertize (all-the-icons-octicon "clock")
                         'face `(:foreground "#b8bb26"
                                             :family ,(all-the-icons-octicon-family)
                                             :height 1.2
                                             ))
             (format-time-string "%H:%M" (current-time))
             '(:foreground "#b8bb26"))

;; Choose which eshell-funcs to enable
(setq eshell-funcs (list esh-dir esh-git esh-clock))

;; Enable the new eshell prompt
(setq eshell-prompt-function 'esh-prompt-func)

(defun sgt/eshell-up-dir ()
  (interactive)
  (eshell/cd "..")
  (eshell-kill-input)
  (eshell-send-input))

(defun sgt/setup-eshell-keybindings ()
  (projectile-mode -1)
  (general-define-key
   :keymaps 'eshell-mode-map
   :states '(normal visual insert)
   "C-l" 'eshell/clear
   "C-h" 'sgt/eshell-up-dir)
  (general-define-key
   :keymaps 'eshell-mode-map
   :states '(normal visual)
   :prefix ","
   "k" 'eshell-life-is-too-much
   "t" 'eshell-truncate-buffer))

(use-package eshell
  :hook (eshell-mode . sgt/setup-eshell-keybindings)
  :config
  ;; some stuff to attempt to speed up eshell + tramp
  (setq remote-file-name-inhibit-cache nil)
  (setq vc-ignore-dir-regexp (format "%s\\|%s"
                                     vc-ignore-dir-regexp
                                     tramp-file-name-regexp))
  (setq tramp-verbose 6))

(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  ;; Enable in all Eshell buffers.
  (eshell-syntax-highlighting-global-mode +1))

(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(setq tramp-default-method "ssh")

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package ess)

(use-package shadchen)

(use-package vdiff)

(use-package company-coq
  :general
  (:states '(normal visual emacs)
           :prefix ","
           "d" 'company-coq-doc
           "jd" 'company-coq-jump-to-definition))

(use-package proof-general
  :after company-coq
  :hook (coq-mode . company-coq))

(use-package simple-httpd)

(use-package org
  :hook ((org-mode . sgt/org-mode-setup))
  :config
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  (advice-add 'org-agenda-quit :after 'org-save-all-org-buffers)
  (plist-put org-format-latex-options :scale 1.7)
  (setq org-latex-create-formula-image-program 'dvisvgm)

  ;; set faces
  (set-face-attribute 'org-agenda-structure nil
                      :inherit 'org-level-1)
  (set-face-attribute 'org-agenda-date nil
                      :inherit 'org-level-2)
  (set-face-attribute 'org-agenda-date-today nil
                      :inherit 'org-level-2)
  (set-face-attribute 'org-agenda-done nil
                      :foreground 'nil
                      :inherit 'font-lock-string-face
                      :slant 'italic
                      :weight 'light)
  (set-face-attribute 'org-time-grid nil
                      :font sgt/fixed-font-name
                      :foreground 'nil
                      :inherit 'org-level-3
                      :weight 'light))

(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (evil-set-initial-state 'org-agenda-mode 'motion))

;; This is needed as of Org 9.2
(require 'org-tempo)

(use-package org-contrib)

(general-define-key
 :states '(normal visual emacs)
 :prefix "SPC"
 "oa" 'org-agenda
 "oc" 'sgt/org-capture-dispatch)

(general-define-key
 :keymaps 'org-mode-map
 :states '(normal visual)
 :prefix ","

 "b" '(:ignore t :wk "Babel")
 "bt" 'sgt/babel-tangle-at-point
 "bT" 'org-babel-tangle
 "bn" 'org-babel-next-src-block
 "bp" 'org-babel-previous-src-block
 
 "i" '(:ignore t :wk "Insert")
 "il" 'org-insert-link
 "ic" 'org-toggle-checkbox

 "ee" 'sgt/exec-and-view
 "es" 'sgt/exec-subtree-and-view
 "el" 'org-edit-latex-environment

 "o" '(:ignore t :wk "Org")
 "oo" 'org
 "oe" 'org-export-dispatch
 "op" 'org-publish-project

 "t" 'org-todo
 "r" 'org-refile
 "d" 'org-deadline
 "k" 'org-set-tags-command
 "s" 'org-schedule
 "#" 'org-update-statistics-cookies

 "S" '(:ignore t :wk "table")
 "Ss" 'org-table-sort-lines

 "T" '(:ignore t :wk "Toggle")
 "Ti" 'org-toggle-inline-images
 "Tl" 'org-latex-preview

 "p" '(:ignore t :wk "Properties")
 "pa" 'org-set-property)

(general-define-key
 :keymaps 'org-agenda-mode-map
 :states 'motion
 ;; motion keybindings
 "j" 'org-agenda-next-line
 "k" 'org-agenda-previous-line
 "c" 'org-agenda-capture
 "gj" 'org-agenda-next-item
 "gk" 'org-agenda-previous-item
 "gH" 'evil-window-top
 "gM" 'evil-window-middle
 "gL" 'evil-window-bottom
 "C-j" 'org-agenda-next-item
 "C-k" 'org-agenda-previous-item
 "[[" 'org-agenda-earlier
 "]]" 'org-agenda-later
 
 ;; actions
 "t" 'org-agenda-todo
 "r" 'org-agenda-refile
 "d" 'org-agenda-deadline
 "s" 'org-agenda-schedule

 ;; goto
 "." 'org-agenda-goto-today
 
 ;; refresh
 "gr" 'org-agenda-redo
 "gR" 'org-agenda-redo-all

 ;; quit
 (kbd "<escape>") 'org-agenda-quit)

(general-define-key
 :keymap 'org-capture-mode
 :states '(normal visual emacs)
 :prefix ","
 "c" 'org-capture-finalize
 "k" 'org-capture-kill
 "r" 'org-capture-refile
 "d" 'org-deadline)

(defun sgt/capture-templates ()
  `(("t" "Task [Inbox]" entry (file+headline "~/OrgFiles/Inbox.org" "Inbox")
     "* TODO %?\n %U\n %i" :empty-lines 1)

    ("l" "Task w/ Link [Inbox]" entry (file+headline "~/OrgFiles/Inbox.org" "Inbox")
     "* TODO %?\n %U\n %a\n %i" :empty-lines 1)

    ("p" "Project" entry (file "~/OrgFiles/Projects.org")
     "* %? [/]\n:PROPERTIES:\n:COOKIE_DATA: todo\n:END:")

    ("j" "Journal" entry
     (file+olp+datetree "~/OrgFiles/Journal.org")
     "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
     :clock-in :clock-resume
     :empty-lines 1)))

(setq org-imenu-depth 4
      org-ellipsis "..."
      org-src-tab-acts-natively t
      org-startup-folded 'overview
      org-edit-src-content-indentation 0
      org-src-preserve-indentation t
      org-hide-emphasis-markers t
 )

(setq org-agenda-files
      '("~/OrgFiles/Inbox.org"
        "~/OrgFiles/Projects.org"
        "~/OrgFiles/org-data/calendar.org")
      org-refile-targets
      '(("~/OrgFiles/Archive.org" :maxlevel . 1)
        ("~/OrgFiles/Projects.org" :maxlevel . 1))
      org-agenda-start-with-log-mode t
      org-agenda-window-setup 'current-window

      org-log-done 'time
      org-log-into-drawer t
      org-clock-clocked-in-display 'frame-title

      org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d!)"))
      org-tag-alist
      '((:startgroup)
        ;; mutually exclusive tags
        ("low_priority" . ?l)
        ("high_priority" . ?h)
        (:endgroup)
        ("paper" . ?p))

      org-agenda-custom-commands
      '(("i" "Inbox"
         ((todo "TODO"
             ((org-agenda-files '("~/OrgFiles/Inbox.org"))))))
        ("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))
          (todo "WAITING"
                ((org-agenda-overriding-header "Waiting On Something")))
          (todo "TODO"
                ((org-agenda-files '("~/OrgFiles/Inbox.org"))
                 (org-agenda-overriding-header "Inbox"))))))
      
      org-capture-templates (sgt/capture-templates))

(setq org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ Now"
      org-agenda-time-grid
      '((today require-timed remove-match)
        (800 1000 1200 1400 1600 1800 2000)
        "      "
        "┈┈┈┈┈┈┈┈┈┈┈┈┈")
      ;; org-agenda-breadcrumbs-separator " ❱ "
      org-agenda-block-separator ?═)

(use-package org-ics
  :straight (org-ics :type git :host github :repo "sgpthomas/org-ics.el")
  :general
  (:states '(normal visual emacs)
           :prefix "SPC"
           "oi" 'org-ics/import-all)
  :custom
  (org-ics/calendars
   `((:name "Test"
            :url ,(s-concat "https://"
                            "calendar.google.com/calendar/ical/"
                            "sgtpeacock%40utexas.edu/"
                            "private-6382215cc9d4e1bb8659bbe82e5f7a0a/"
                            "basic.ics")
            :destination "~/OrgFiles/org-data/calendar.org"
            :category "Test"
            :file-tag "Event")
     ;; (:name "GRACS"
     ;;             :url ,(s-concat "https://"
     ;;                             "calendar.google.com/calendar/ical/"
     ;;                             "utgracs%40gmail.com/"
     ;;                             "public/"
     ;;                             "basic.ics")
     ;;             :destination "~/OrgFiles/org-data/gracs.org"
     ;;             :category "Event"
     ;;             :file-tag "Event")
     )))

(defun sgt/exec-and-view ()
  (interactive)
  (org-babel-execute-maybe)
  (org-display-inline-images))

(defun sgt/exec-subtree-and-view ()
  (interactive)
  (org-babel-execute-subtree)
  (org-display-inline-images))

(defun sgt/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (sgt/setup-electric-pairs)
  (setq evil-auto-indent 1)
  (setq-local prettify-symbols-alist
              '(("#+begin_src"  . ?λ)
                ("#+end_src" . ?●)
                ("#+begin_example" . ?¶)
                ("#+end_example" . ?●)
                ("#+begin_export" . ?)
                ("#+end_export" . ?●)))
  (prettify-symbols-mode 1)
  (flyspell-mode 1)
  (message "Ran custom org mode setup."))

(defun org-global-props (&optional property buffer)
  "Get the plists of global org properties of current buffer."
  (unless property (setq property "PROPERTY"))
  (with-current-buffer (or buffer (current-buffer))
    (org-element-map (org-element-parse-buffer) 'keyword
      (lambda (el) (when (string-match property (org-element-property :key el)) el)))))

(defun sgt/should-tangle ()
  "Determines whether this file has the :tangle property"
  (let* ((prop (car (org-global-props "PROPERTY")))
         (str (org-element-property :value prop)))
    (cl-search ":tangle" str)))

(defun sgt/org-babel-tangle-config ()
  (when (sgt/should-tangle)
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle "~/.emacs.d/init.el"))))

(defun sgt/org-indent-buffer ()
  (interactive)
  (org-indent-region (point-min) (point-max)))

(defun sgt/setup-electric-pairs ()
  (setq-local electric-pair-pairs
              '((?\" . \")
                (?\{ . \})
                (?\[ . \])
                (?\{ . \})))
  (setq-local electric-pair-text-pairs electric-pair-pairs))

(defun sgt/babel-get-var (var)
  "Get a variable from the current var list."
  (--> (save-excursion
         (outline-up-heading 1)
         (org-babel-params-from-properties))
       (car it)
       (org-babel--get-vars it)
       (--map (split-string it "=") it)
       (--find (equal (car it) var) it)
       (cadr it)
       (string-remove-prefix "\"" it)
       (string-remove-suffix "\"" it)))

(defun sgt/babel-tangle-at-point ()
  (interactive)
  (let ((current-prefix-arg '(4)))
    (call-interactively 'org-babel-tangle)))

(add-hook 'org-mode-hook
          (lambda () (add-hook 'after-save-hook
                          #'sgt/org-babel-tangle-config
                          nil
                          'local)))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(font-lock-add-keywords
 'org-mode
 '(("^ *\\([-]\\) "
    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-indent)
;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-property-value nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-block-begin-line nil :inherit 'fixed-pitch)
(set-face-attribute 'org-block-end-line nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(fixed-pitch font-lock-builtin-face))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil :inherit 'fixed-pitch)

(require 'org-faces)
(dolist (face '(
                (org-document-title . 1.4)
                (org-level-1 . 1.3)
                (org-level-2 . 1.2)
                (org-level-3 . 1.05)
                (org-level-4 . 1.1)
                (org-level-5 . 1.2)
                (org-level-6 . 1.2)
                (org-level-7 . 1.2)
                (org-level-8 . 1.2)))
  (set-face-attribute (car face) nil
                      :font sgt/variable-font-name
                      :weight sgt/variable-font-heading-weight
                      :height (cdr face)))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

(set-face-attribute 'org-block-begin-line nil
                    :font sgt/fixed-font-name
                    :slant 'normal
                    :underline nil
                    :background (face-attribute 'org-block :background)
                    :foreground (face-attribute 'font-lock-comment-face :foreground)
                    :extend t)

(set-face-attribute 'org-block-end-line nil
                    :font sgt/fixed-font-name
                    :slant 'normal
                    :background (face-attribute 'org-block :background)
                    :foreground (face-attribute 'font-lock-comment-face :foreground)
                    :extend t)

(defun sgt/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . sgt/org-mode-visual-fill))

(defun sgt/--oc-helper (template)
  (let* ((key (nth 0 template))
         (name (nth 1 template)))
    (list key name `(lambda () (interactive)
                      (let ((org-capture-entry (org-capture-select-template ,key)))
                        (org-capture))))))

(defun sgt/org-capture-dispatch ()
  (interactive)
  (let* ((options (--map (sgt/--oc-helper it) (sgt/capture-templates)))
         (trans `(transient-define-prefix sgt/--org-capture-dispatch
                   "test"
                   ["Templates:"
                    ,@options]
                   ["Quit"
                    ("q" "Quit" (lambda () (interactive)))])))
    (eval trans)
    (sgt/--org-capture-dispatch)))

(use-package ob-json
  :straight (ob-json :type git :host github :repo "sgpthomas/ob-json")
  ;; (ec2 :type git :host github :repo "sgpthomas/ec2.el")
  )

(use-package ob-acl2
  :straight (ob-acl2 :type git :host github :repo "sgpthomas/ob-acl2"))

(use-package ob-async-shell
  :straight (ob-async-shell :type git :host github :repo "sgpthomas/ob-async-shell"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (R . t)
   (eshell . t)
   (json . t)
   (shell . t)
   (acl2 . t)
   (async-shell . t)))

(setq org-confirm-babel-evaluate nil)

(use-package ob-async
  :config
  (setq ob-async-no-async-languages-alist '("python" "ipython")))

(use-package htmlize)

(require 'ox-publish)
(require 's)

(setq org-image-actual-width nil ; don't use real image width in org mode
      org-html-validation-link nil) ; don't include those valide links in html export

;; variable for if we are in publishing mode or not.
(setq sgt/publish 'nil)

(defun sgt/resolve (path)
  "If `sgt/publish' is set, return normal path, else return local tmp path."
  (if sgt/publish
      path
    "/tmp/html/"))

(defun sgt/set-publish-projects ()
  "Function that set's up org publish projects."
  (setq org-publish-project-alist
        `(("personal-website-org"
           :base-directory "~/OrgFiles/personal-website/"
           :base-extension "org"
           :publishing-directory ,(sgt/resolve "/ssh:samthomas@sgtpeacock.com:~/public/")
           :recursive t
           :publishing-function org-html-publish-to-html 
           :headline-levels 4
           :html-validation-link nil
           :html-postamble nil
           :auto-preamble nil)
          ("personal-website-static"
           :base-directory "~/OrgFiles/personal-website"
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf"
           :publishing-directory ,(sgt/resolve "/ssh:samthomas@sgtpeacock.com:~/public/")
           :recursive t
           :publishing-function org-publish-attachment)
          ("personal-website"
           :components ("personal-website-org" "personal-website-static"))

          ("emacs-config"
           :base-directory "~/DotFiles/"
           :base-extension "org"
           :publishing-directory ,(sgt/resolve "/ssh:samthomas@sgtpeacock.com:~/public/dot-files/")
           :recursive t
           :publishing-function org-html-publish-to-html
           :html-validation-link nil)

          ("spring-22-ping-pong"
           :base-directory "~/OrgFiles/ping-pong"
           :base-extension "org"
           :exclude "notes.org"
           :publishing-directory ,(sgt/resolve "/ssh:sgt@pebbles.cs.utexas.edu:/u/www/users/gracs/pingpong/")
           :recursive t
           :publishing-function org-html-publish-to-html
           :html-postamble nil
           :html-validation-link nil))))
;; call the function so that this variable is set on load
(sgt/set-publish-projects)

(defun sgt/setup-publish-projects ()
  "Change between `publish' and `develop' mode for `org-publish'."
  (interactive)
  (let ((res (completing-read "Publish mode: " '("publish" "develop"))))
    (cond
     ((s-equals? "publish" res)
      (setq sgt/publish t)
      (httpd-stop))
     ((s-equals? "develop" res)
      (setq sgt/publish nil)
      (httpd-serve-directory "/tmp/html/"))))
  (sgt/set-publish-projects))

(defun sgt/open-config ()
  "Open config file."
  (interactive) 
  (find-file sgt/config-file))

(defun sgt/reload-config ()
  "Reload config file."
  (interactive)
  (org-babel-tangle-file sgt/config-file)
  (load-file "~/.emacs.d/init.el"))

(defun sgt/change-session-font-size ()
  "Change the font size for the session."
  (interactive)
  (let ((fixed-font-size
              (read-number "Font size:" sgt/default-font-size)))

    ;; set font
    (set-face-attribute 'default nil
                        :font sgt/fixed-font-name
                        :height fixed-font-size)

    ;; Set the fixed pitch face
    (set-face-attribute 'fixed-pitch nil
                        :font sgt/fixed-font-name
                        :height fixed-font-size)

    ;; Set the variable pitch face
    (set-face-attribute 'variable-pitch nil
                        :font sgt/variable-font-name
                        :height (+ 5 fixed-font-size)
                        :weight 'regular)))
