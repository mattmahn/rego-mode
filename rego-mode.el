;;; rego-mode.el --- Support for the Rego language

;; Copyright (C) 2020 Matthew Mahnke

;; Author: Matthew Mahnke
;; Created: 16 Aug 2020
;; Package-Requires: (emacs)
;; Keywords: rego opa open-policy-agent
;; URL: https://github.com/mattmahn/rego-mode
;; SPDX-License-Identifier: BSD-3-Clause

;;; Commentary:

;; Provides a major mode `rego-mode' for use with the Rego language of
;; the Open Policy Agent project.

;;; Code:

(defgroup rego nil
  "Major mode for editing Rego files."
  :prefix "rego-mode-"
  :link '(url-link "https://github.com/mattmahn/rego-mode")
  :group 'languages)

(defcustom rego-mode-hook nil
  "Hooks called by `rego-mode'."
  :type 'hook
  :group 'rego)

(defcustom opa-executable
  (or (executable-find "opa")
      "opa")
  "The path to the Open Policy Agent 'opa' executable."
  :type 'string
  :group 'rego)

;; (defvar rego-mode-map
;;   (make-sparse-keymap))


;;;; Syntax highlighting

;; Some regular syntax matching sourced from
;; the VSCode OPA plugin
;; (https://github.com/open-policy-agent/vscode-opa/blob/master/syntaxes/Rego.tmLanguage)
;; or the Rego policy reference doc
;; (https://www.openpolicyagent.org/docs/latest/policy-reference/)

(defface rego-constant-face '((t :inherit (font-lock-constant-face)))
  "Face for constants."
  :group 'rego)

(defface rego-function-call-face '((t :inherit (font-lock-function-name-face)))
  "Face for function calls."
  :group 'rego)

(defface rego-keyword-face '((t :inherit (font-lock-keyword-face)))
  "Face for keywords."
  :group 'rego)

(defface rego-raw-string-face '((t :inherit (font-lock-string-face)))
  "Face for raw, backtick-delimited strings."
  :group 'rego)

(defconst rego-mode-constants '("false" "null" "true"))

(defconst rego-mode-keywords '("as" "default" "else" "import" "package" "not" "with"))

(defconst rego-mode-font-lock-keywords
  (let* (
	 (x-keywords-regexp (regexp-opt rego-mode-keywords 'words))
	 (x-constants-regexp (regexp-opt rego-mode-constants 'words))
	 )
    `( ;; NOTE: oder matters; once colored, it won't change
      (,x-keywords-regexp . 'rego-keyword-face)
      (,x-constants-regexp . 'rego-constant-face)
      ("-?\\(?:0\\|[1-9][[:digit:]]*\\)\\(?:\\(?:\\.[[:digit:]]+\\)?\\(?:[eE][+-]?[[:digit:]]+\\)?\\)?" . 'rego-constant-face) ; numbers
      ("\\([a-zA-Z_][a-zA-Z_0-9]*\\)(" 1 'rego-function-call-face) ; function calls & definitions
      ("`[^`]*`" . 'rego-raw-string-face) ; raw string
      )))

(defvar rego-mode-syntax-table
  (let ((syn-table (make-syntax-table)))
    (modify-syntax-entry ?# "<" syn-table)
    (modify-syntax-entry ?\n ">" syn-table)
    syn-table)
  "Syntax table for `rego-mode'.")

;;;;

(define-abbrev-table 'rego-mode-abbrev-table nil
  "Abbrev table used while in `rego-mode'.")

(defun rego-completion-at-point ()
  "Provides completions for rego-mode."
  (interactive)
  (let* ((bds (bounds-of-thing-at-point 'symbol))
	 (start (car bds))
	 (end (cdr bds)))
    `(,start ,end ,`(,@rego-mode-constants ,@rego-mode-keywords) . nil)))

(defun rego-format-buffer ()
  "Rewrite the current buffer in the canonical format using `opa fmt'."
  (interactive)
  (let ((buf (get-buffer-create "*opa-fmt*")))
    (if (zerop (call-process-region (point-min) (point-max)
				    opa-executable nil buf nil "fmt"))
	(let ((point (point))
	      (window-start (window-start)))
	  (erase-buffer)
	  (insert-buffer-substring buf)
	  (goto-char point)
	  (set-window-start window-start))
      (mesage "opa fmt: %s" (with-current-buffer buf (buffer-string))))
    (kill-buffer buf)))

;;;###autoload
(define-derived-mode rego-mode prog-mode "Rego"
  "Major mode for editing Rego policy files."
  (setq-local font-lock-defaults '(rego-mode-font-lock-keywords))
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (set-syntax-table rego-mode-syntax-table)
  (add-hook 'completion-at-point-functions 'rego-completion-at-point nil 'local)
  )

(define-minor-mode rego-format-on-save-mode
  "Run `rego-format-buffer' before saving current buffer."
  :group 'rego
  (if rego-format-on-save-mode
      (add-hook 'before-save-hook #'rego-format-buffer nil t)
    (remove-hook 'before-save-hook #'rego-format-buffer t)))

(provide 'rego-mode)

;;; rego-mode.el ends here
