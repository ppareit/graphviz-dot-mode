graphviz-dot-mode
=====================

[Emacs](https://www.gnu.org/software/emacs/) package for working with
[Graphviz](https://graphviz.org) DOT-format files.

The features of this package help you to create `.dot` or `.gv` files
containing syntax compatible with Graphviz and use Graphviz to convert
these files to diagrams. [Graphviz](https://graphviz.org) is a set of
open source graph visualization tools created by AT&T Labs Research. A
graph is a way of representing information as a network of connected
nodes (shapes) and edges (lines).

Installing
============

Dependencies
--------------

This of course depends on Emacs and Graphviz. Installation from the
command prompt should be something like

``` shell
$ sudo dnf install emacs graphviz
```

Setting up MELPA
-------------------

Add the [MELPA](https://melpa.org/) archive to the list of archives
used by the Emacs package manager by adding the following lines to
your `.emacs` or other Emacs start-up file.

``` emacs-lisp
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
```
Evaluate above code or restart Emacs.

Setting up use-package
---------------------------

Add the [`use-package`](https://jwiegley.github.io/use-package/)
package to your Emacs by adding the following lines to your start-up
file.

``` emacs-lisp
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
```
Evaluate above code or restart Emacs.
	  
Setting up graphviz-dot-mode
----------------------------------

Now you can finally add Graphviz support to your Emacs by adding the
following lines to your startup file.

``` emacs-lisp
(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))
```

Evaluate above code or restart Emacs.

Using `graphviz-dot-mode`
==============================

Once installation and setup is completed, usage is as simple as
creating or opening a `.dot` file with `C-x C-f` (`find-file`). The
file will open in dot mode.  Syntax should be highlighted, completion
should work and viewing your work is only one keystroke away with `C-c
C-p`. Some useful commands are described below.

### Indenting

* `C-M-q` (`graphviz-dot-indent-graph`)

  This command will indent the graph, digraph, or subgraph at point
and any subgraph within it.

* `TAB`

  This key will automatically indent the line.

### Completion

Is available and makes use of the facilities provided by Emacs. Your
preferred completion framework should plug into this.

For instance, if you use company, it can be configured by adding the
following line to your startup file.

``` emacs-lisp
(add-hook 'graphviz-dot-mode-hook 'company-mode)
```

### Commenting

* `M-;` (`comment-dwim`)

  This command will perform the comment command you want (Do What I
Mean).  If the region is active and `transient-mark-mode` is on, it
will comment the region, unless it only consists of comments, in which
case it will un-comment the region. Else, if the current line is
empty, it will insert a blank comment line, otherwise it will append a
comment to the line and indent it.

  Use `C-u M-;` to kill the comment on the current line.

* `C-x C-;` (`comment-line`)

  This command will comment or un-comment the current line.

* `M-j` (`comment-indent-newline`)

  This command will break line the at point and indent, continuing a
comment if within one. This indents the body of the continued comment
under the previous comment line.

### Compiling

* `C-c C-c` (`compile`)
  
  This command compiles the current dot file visited by the Emacs
buffer.  The output file is in the same directory and has the
extension determined by the variable `graphviz-dot-preview-extension`.

* `` C-x ` `` (`next-error`)

  This command will jump to the location in the source file of the
next error from the most recent compile. Use `C-c C-c` to compile first.

### Viewing

* `C-c C-p` (`graphviz-dot-preview`)
  
  This command compiles and then (if it compiled successfully) shows
the output of the current dot file visited by the Emacs buffer,
provided that Emacs is running on a graphical display capable of
displaying the graphic file output by `dot`.

  See `image-file-name-extensions` to customize the graphic files that
  can be displayed.

* `C-c C-v` (`graphviz-dot-view`)

  This command invokes an external viewer specified by the variable
`graphviz-dot-view-command`. If `graphviz-dot-view-edit-command` is
`t`, you will be prompted to enter a new
`graphviz-dot-view-command`. If `graphviz-dot-save-before-view` is
`t`, the buffer is saved before the external viewer command is
invoked.

  See <https://graphviz.gitlab.io/resources/> for a list of Graphviz
  viewers.


Customizing
=============

You may customize variables by typing

`M-x graphviz-dot-customize RET`

or by setting them to different values in your start-up file.

* `graphviz-dot-dot-program` string, default: “dot”

  This variable determines the command name (and path, if necessary)
used to invoke the Graphviz `dot` program. The `C-c C-c` (`compile`)
function invokes this command.

* `graphviz-dot-preview-extension` string, default “png”

  This variable determines the file extension used for the `C-c C-c`
(`compile`) and `C-c C-p` (`graphviz-dot-preview`) functions. The
format for the compile command is

  `dot -T<extension> <filename>.dot > <filename>.<extension>`

* `graphviz-dot-save-before-view` boolean, default `t`

  This variable controls whether the buffer will be saved to the
visited file before the `C-c C-v` (`graphviz-dot-view`) function
invokes the external dot-file viewer command. Set this boolean
variable to `t` (true) or `nil` (false).

* `graphviz-dot-view-command` string, default: “dotty %s”

  This variable determines the command name (and path, if necessary)
used to invoke an external dot-file viewer program. The `C-c C-v`
(`graphviz-dot-view`) function invokes this command. The name of the
file visited by the buffer will be substituted for `%s` in this
string.

  See <https://graphviz.gitlab.io/resources/> for a list of Graphviz
viewers.

* `graphviz-dot-view-edit-command` boolean, default: `nil`

  This variable controls whether you will be prompted for the external
dot-file viewer command name when you use `C-c C-v`
`graphviz-dot-view`.  Set this to `t` (true) to be prompted to edit
the viewer command variable `graphviz-dot-view-command` every time you
use `C-c C-v` or `nil` to avoid the prompt.

* `graphviz-dot-indent-width` integer, default: `default-tab-width`

  This variable determines the indentation used in `graphviz-dot-mode`
buffers.

* `graphviz-dot-mode-hook` list of functions, default: `nil`

  This variable determines which functions are called when
`graphviz-dot-mode` starts. To use it, add a line like below to your
`.emacs` or other startup file.

``` emacs-lisp
(add-hook 'graphviz-dot-mode-hook 'my-hook)
```

Support
========

* Issues, requests and questions can go on its issue tracker:
  <https://github.com/ppareit/graphviz-dot-mode/issues>
* This mode is maintained at its github page:
  <https://github.com/ppareit/graphviz-dot-mode>
* You can support the maintainer through a [paypal donation](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ZBVLYKWYMXQ3G)

Credits
========

`graphviz-dot-mode` was written by:

* Pieter Pareit <pieter.pareit@gmail.com>
* Rubens Ramos <rubensr@users.sourceforge.net>
* Eric Anderson <http://www.ece.cmu.edu/~andersoe/>
* Daniel Birket <danielb@birket.com>

Other contributors are noted in the version history in the
`graphviz-dot-mode.el` file and the commit history on GitHub.

The source code is maintained on GitHub at
<https://github.com/ppareit/graphviz-dot-mode> by Pieter Pareit
(<pieter.pareit@gmail.com>).
