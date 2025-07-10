;;; graphviz-dot-flycheck.el --- Flychecker for graphviz.   -*- lexical-binding: t; -*-

;; Part of graphviz-dot-mode, see https://ppareit.github.io/graphviz-dot-mode/

;; Copyright (C) 2025 - 2025 Pieter Pareit <pieter.pareit@gmail.com>

;; Package-Requires: ((emacs "25.0") (flycheck "20250527.907"))

;;; Commentary:
;;
;;; Todo:
;;
;;; Code:
(require 'flycheck)

(defun graphviz-dot--add-column-to-error (err)
  "Attach :column and :end-column to a ERR so we underline the exact token."
  (when-let* ((msg   (flycheck-error-message err))
	      (buf   (flycheck-error-buffer  err))
	      ((buffer-live-p buf))                ; buffer may have died
	      (line  (flycheck-error-line    err))
	      (_     (string-match "near '\\([^']+\\)'" msg))
	      (token (match-string 1 msg)))
    (with-current-buffer buf
      (save-excursion
        (goto-char (point-min))
        (forward-line (1- line))                   ; line is 1-based
        (when-let* ((end   (search-forward token (line-end-position) t))
		    (start (- end (length token)))
		    (bol   (line-beginning-position)))
          (setf (flycheck-error-column      err) (1+ (- start bol))
                (flycheck-error-end-column  err) (1+ (- end   bol)))))))
  err)

(defun graphviz-dot--prettify-error-message (err)
  "Tweak a single Flycheck ERR from the Graphviz checker."
  (when-let ((msg (flycheck-error-message err)))
    ;; Drop “gvrender_set_style: ”
    (setq msg (replace-regexp-in-string "\\`gvrender_set_style: *" "" msg))
    ;; Drop “using box for ”
    (setq msg (replace-regexp-in-string "\\`using box for *" "" msg))
    ;; Trim “ - ignoring[.]” at the end.
    (setq msg (replace-regexp-in-string " - ignoring\\.?\\s-*\\'" "" msg))
    ;; Turn bare “near 'foo'” into a full sentence.
    (when (string-match "\\` *near '[^']+'\\'" msg)
      (setq msg (concat "Syntax error " msg)))
    ;; Save result back into ERR.
    (setf (flycheck-error-message err) msg))
  err)

(defun graphviz-dot--search-regex-from-msg (msg)
  "Return regexp for MSG.

Return a regexp that should locate the first occurrence of the
offending token mentioned in Graphviz warning MSG."
  (cond
   ;; unknown shape
   ((string-match "unknown shape[[:space:]]+\\([[:alnum:]_-]+\\)" msg)
    (format "\\bshape[[:space:]]*=[[:space:]]*\"?%s\\b"
	    (regexp-quote (match-string 1 msg))))
   ;; unsupported style
   ((string-match "unsupported style[[:space:]]+\\([[:alnum:]_-]+\\)" msg)
    (format "\\bstyle[[:space:]]*=[[:space:]]*\"?%s\\b"
	    (regexp-quote (match-string 1 msg))))
   ;; TOKEN is not a known color
   ;;    colour shows up in color=, fontcolor=, fillcolor= so allow any of them
   ((string-match "\\`\\([^[:space:]]+\\)[[:space:]]+is not a known color" msg)
    (format "\\b\\(?:color\\|fontcolor\\|fillcolor\\)[[:space:]]*=[[:space:]]*\"?%s\\b"
	    (regexp-quote (match-string 1 msg))))
   ;; Arrow type "TOKEN" unknown
   ;;    * arrowhead=TOKEN
   ;;    * arrowtail = "fooTOKENbar"
   ((string-match "Arrow type \"\\([^\"]+\\)\" unknown" msg)
    (let ((tok (regexp-quote (match-string 1 msg))))
      ;; arrow(head|tail) *= *"?(anything)*TOKEN(anything)*"?   (no newline)
      (format
       "\\barrow\\(?:head\\|tail\\)[[:space:]]*=[[:space:]]*\"?[^\"\n]*%s[^\"\n]*\"?"
       tok)))
   ;; port "TOKEN" unrecognized
   ;;    search for  :TOKEN   (optionally with spaces or quotes)
   ((string-match "port \"?\\([^\"]+\\)\"? unrecognized" msg)
    (format ":[[:space:]]*\"?%s\\b"
	    (regexp-quote (match-string 1 msg))))
   ;; there could be more warnings, but I'm unable to trigger them
   ;; let me know any missing, with an example to trigger
   (t nil)))

(defun graphviz-dot--add-line-and-column-to-error (err)
  "Populate :line / :column / :end-column for Graphviz warning ERR."
  (when (eq (flycheck-error-level err) 'warning)
    (when-let* ((msg   (flycheck-error-message err))
                (buf   (flycheck-error-buffer  err))
                (regex (graphviz-dot--search-regex-from-msg msg)))
      (with-current-buffer buf
        (save-excursion
          (goto-char (point-min))
          (re-search-forward regex nil t)
          (when-let* ((beg (match-beginning 0))
		      (end (match-end 0))
		      (bol (progn (goto-char beg) (line-beginning-position))))
	    (setf (flycheck-error-line        err) (line-number-at-pos beg)
                  (flycheck-error-column      err) (1+ (- beg bol))
                  (flycheck-error-end-column  err) (1+ (- end bol))))))))
  err)

(defun graphviz-dot--dedup-errors (errors)
  "Return ERRORS without duplicates (same buffer/line/column/message)."
  (let ((seen (make-hash-table :test #'equal))
        out)
    (dolist (err errors (nreverse out))
      (let ((key (list (flycheck-error-buffer  err)
		       (flycheck-error-line    err)
		       (flycheck-error-column  err)
		       (flycheck-error-message err))))
        (unless (gethash key seen)
          (puthash key t seen)
          (push err out))))))


(flycheck-define-checker graphviz-dot
  "A Graphviz dot file syntax checker.."
  :command ("dot"
	    "-T" "dot"       ; No graphics, for speed
	    "-o" "/dev/null" ; No output, for speed
	    source-inplace)
  :error-patterns
  (;; line number and near message
   (error line-start "Error: " (file-name) ": syntax error in line " line " "
          (message)
          line-end)
   ;; line number and no message
   (error   line-start "Error: " (file-name) ": syntax error in line "
	    line line-end)
   ;; all the rest are warnings
   (warning line-start "Warning: " (message (one-or-more not-newline)) line-end))
  :error-filter
  (lambda (errors)
    (dolist (err errors errors)
      (unless (flycheck-error-message err)
        (setf (flycheck-error-message err) "syntax error"))
      (graphviz-dot--add-column-to-error    err)
      (graphviz-dot--prettify-error-message err)
      (graphviz-dot--add-line-and-column-to-error err))
    (flycheck-fill-empty-line-numbers errors)
    (flycheck-sanitize-errors errors)
    (graphviz-dot--dedup-errors errors))
  :modes (graphviz-dot-mode))

;; And add it to flycheck's list of checkers
(add-to-list 'flycheck-checkers 'graphviz-dot)

(provide 'graphviz-dot-flycheck)
;;; graphviz-dot-flycheck.el ends here
