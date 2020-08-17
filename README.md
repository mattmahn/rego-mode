rego-mode is an Emacs major mode for [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/), the language used by [Open Policy Agent](https://openpolicyagent.org/).


# Features

- [x] syntax highlighting
- [x] run `opa fmt` on save to format file: `(add-hook 'rego-mode-hook #'rego-format-on-save-mode)`
- [ ] highlight syntax errors in file
- [ ] upload file to [OPA Playground](https://play.openpolicyagent.org/)
	- [ ] upload data file
- [ ] run tests in project
	- [ ] integrate with [Projectile](https://docs.projectile.mx/projectile/index.html)


# Installation

There are a couple differet ways to install rego-mode.  The first is adding `rego-mode.el` to a directory in your `load-path`:
```emacs-lisp
(add-to-list 'load-path "/your/path/to/rego-mode")
(require 'rego-mode)
(add-to-list 'auto-mode-alist '("\\.rego\\'" . rego-mode))
```

<!-- FIXME add to MELPA
You can also use one of these:

## use-package

```emacs-lisp
(use-package rego-mode
  :mode "\\.rego\\'")
```
-->
