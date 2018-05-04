;;; company-graphviz-dot.el --- Company completion function for
;;; graphviz-dot-mode

;; Copyright (C) Bjarte Johansen <bjarte.johansen@gmail.com>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;; Author: Bjarte Johansen <bjarte.johansen@gmail.com>
;; Homepage: http://ppareit.github.com/graphviz-dot-mode/
;; Created:
;; Last modified:
;; Version: 0.0.1
;; Keywords: mode dot dot-language dotlanguage graphviz graphs att company

;;; Commentary:


;;; Code:

(require 'company)
(require 'graphviz-dot)

(eval-when-compile
  (require 'cl-lib))

(defun company-gz-dot--candidates (arg)
  (cl-destructuring-bind (type . value) arg
    (cl-case type
      (color
       (cl-remove-if-not (lambda (c) (string-prefix-p value c))
                         graphviz-dot-color-keywords))
      (value
       (cl-remove-if-not (lambda (c) (string-prefix-p value c))
                         graphviz-dot-value-keywords)))
      ((comment string) nil)
      (t (cl-remove-if-not (lambda (c) (string-prefix-p value c))
                           graphviz-dot-attr-keywords)))))

(defun company-gz-dot--prefix ()
  (let ((state (syntax-ppss)))
    (cond ((nth 4 state) 'comment)
          ((nth 3 state) 'string)
          ((not (nth 1 state)) 'out)
          ((save-excursion
             (skip-chars-backward "^[,=\\[]{};")
             (backward-char)
             (looking-at "="))
           (save-excursion
             (backward-word 1)
             (if (looking-at "[a-zA-Z]*color")
                 'color
               'value)))
          ((save-excursion
             (skip-chars-backward "^[,=\\[]{};")
             (backward-char)
             (looking-at "[\\[,]{};"))
           'attr)
          (t 'other))))


(defun company-graphviz-dot (command &optional arg &rest ignored)
  "`company-mode' completion back-end for `sparql-mode'. Right
now it only completes prefixes, `company-keywords' takes care of
keywords."
  (interactive (list 'interactive))
  (cl-case command
    (init)
    (interactive (company-begin-backend 'company-graphviz-dot))
    (prefix (and (eq major-mode 'graphviz-dot-mode)
                 (company-gz-dot--prefix)))
    (candidates (company-gz-dot--candidates arg))
    (require-match 'never)))


(provide company-graphviz-dot)
