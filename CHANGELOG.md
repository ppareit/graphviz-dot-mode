# History

## Version 0.4.2 – Pieter Pareit (25/01/2020)
- Fix issues
- Improve font-locking
- Improve completion by implementing company mode
- Rewrote basic documentation

## Version 0.4.1 – Pieter Pareit (28/09/2019)
- Maintenance, checking documentation, fixing flycheck errors
- Solve `next-error` for Graphviz
- Tag new version

## Version 0.3.11 – Olli Piepponen (29/01/2016)
- Use `define-derived-mode` for the mode definition
- Add support for an auto-loading live preview workflow

## Version 0.3.10 – Kevin Ryde (25/05/2015)
- Use `shell-quote-argument` for safety
- Use `read-shell-command` whenever available, don't set `novaproc`

## Version 0.3.9 – Titus Barik <titus AT barik.net> (28/08/2012)
- `compile-command` uses `-ofile` instead of `>`

## Version 0.3.8 – New home (27/06/2012)
- Moved graphviz-dot-mode to git, updated links

## Version 0.3.7 – Tim Allen (09/03/2011)
- Fix spaces in file names when compiling

## Version 0.3.6 – Maintenance (19/02/2011)
- `.gv` is the new extension (Pander)
- Comments can start with `#` (Pander)
- Highlight new keywords (Pander)

## Version 0.3.5 – Bug fix (11/11/2010)
- Eric Anderson: Preserve indentation across blank (whitespace-only) lines

## Version 0.3.4 – Bug fixes (24/02/2005)
- Fixed a bug in `graphviz-dot-preview`

## Version 0.3.3 – Bug fixes (13/02/2005)
- Reuben Thomas <rrt AT sc3d.org>: Add `graphviz-dot-indent-width`

## Version 0.3.2 – Bug fixes (25/03/2004)
- Rubens Ramos <rubensr AT users.sourceforge.net>
  - Semi-colons and brackets are added when electric behavior is disabled
  - Electric characters do not behave electrically inside comments or strings
  - Default for electric-braces is now disabled
  - Use `read-from-minibuffer` instead of `read-shell-command` (Emacs)
  - Fixed `easymenu` test for older XEmacs
  - Fixed indentation error on last brace of empty graph
  - Removed `region-active-p` (not available in Emacs 21.2)
  - Added uncomment menu option

## Version 0.3.1 – Bug fixes (03/03/2004)
- `backward-word` needs an argument for older Emacs

## Version 0.3 – New features and bug fixes
- 10/01/2004: Fix bug in `graphviz-dot-indent-graph`
- 08/01/2004: Rubens Ramos
  - Add customization support
  - Works on XEmacs and Emacs
  - Support external viewer
  - Fix startup behavior when buffer has no name
  - Preview works on XEmacs and Emacs
  - Electric indentation on newline
  - Minor indentation tweaks
  - Add keyword completion (still basic)
  - Marked some hacks with `RR`

## Version 0.2 – New features
- 11/11/2002: Add preview support
- 10/11/2002: Indent graph/subgraph with `C-M-q`
- 08/11/2002: Allow extra characters after `graph` keyword (e.g., comments)

## Version 0.1.2 – Bug fixes and naming
- 06/11/2002: Rename `dot-font-lock-defaults` to `dot-font-lock-keywords`
- Add documentation to `dot-colors`
- Fix `max-specpdl-size` handling
- Add autoload cookie

## Version 0.1.1 – Bug fixes
- 06/11/2002: Add missing attribute for font-lock to work
- Fix regex to match whole words
- 05/11/2002: Allow extra whitespace after `{`
- 04/11/2002: Document use of `max-specpdl-size`, restore old value

## Version 0.1 – Initial release
- 02/11/2002: Parser for *compilation* of `.dot` files
- 01/11/2002: Compilation of `.dot` files
- 31/10/2002: Added `syntax-table`
- 30/10/2002: Implemented indentation
- 29/10/2002: Implemented all of font-lock
- 28/10/2002: Derived from `fundamental-mode`, started font-lock implementation
