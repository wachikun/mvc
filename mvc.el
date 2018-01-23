;; mvc.el -- M(eta|ulti|enu) Version Control Interface -*- coding: iso-2022-jp -*-

;; Copyright (C) 2007-2017 Tadashi Watanabe <wac@umiushi.org>

;; Author: Tadashi Watanabe <wac@umiushi.org>
;; Maintainer: Tadashi Watanabe <wac@umiushi.org>
;; Version: 
;; Keywords: tools

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

;;; Commentary:

;; http://umiushi.org/~wac/mvc/

;;; Code:

(defvar mvc-version-string "mvc version 0.3")

(defun mvc-version ()
  (interactive)
  (message mvc-version-string))

(defgroup mvc nil
  "Version control interface for Emacs"
  :group 'tools)
(defgroup mvc-variables nil
  "mvc variables"
  :group 'mvc)
(defgroup mvc-faces nil
  "mvc faces"
  :group 'mvc)

(defcustom mvc-default-status-display-unknown t
  "mvc-default-status-display-unknown"
  :type 'boolean
  :group 'mvc-variables)
(defcustom mvc-default-status-display-unmodified t
  "mvc-default-status-display-unmodified"
  :type 'boolean
  :group 'mvc-variables)
(defcustom mvc-default-status-display-backup nil
  "mvc-default-status-display-backup"
  :type 'boolean
  :group 'mvc-variables)
(defcustom mvc-default-status-display-ignore nil
  "mvc-default-status-display-ignore"
  :type 'boolean
  :group 'mvc-variables)
(defcustom mvc-default-status-display-delete t
  "mvc-default-status-display-delete"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-use-animation-timer t
  "mvc-default-use-animation-timer"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-use-color t
  "mvc-default-use-color"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-use-button t
  "mvc-default-use-button"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-use-tab t
  "mvc-default-use-tab"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-read-directory t
  "mvc-default-read-directory"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-process-connection-type nil
  "mvc-default-process-connection-type"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-process-coding-system '(undecided . undecided)
  "mvc-default-process-coding-system"
  :type '(list symbol symbol)
  :group 'mvc-variables)

(defcustom mvc-default-commitlog-file-coding-system nil
  "mvc-default-commitlog-file-coding-system"
  :type '(list symbol symbol)
  :group 'mvc-variables)

(defcustom mvc-default-tmp-directory "/tmp"
  "mvc-default-tmp-directory"
  :type 'string
  :group 'mvc-variables)

(defcustom mvc-default-program-search-concurrent t
  "mvc-default-program-search-concurrent"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-program-search-order-list '(mercurial git bazaar subversion)
  "mvc-default-program-search-order-list"
  :type '(list symbol symbol symbol symbol symbol)
  :group 'mvc-variables)

(defcustom mvc-default-log-face-limit-float-time 0.5
  "mvc-default-log-face-limit-float-time"
  :type 'float
  :group 'mvc-variables)

(defcustom mvc-default-diff-option-list '((mercurial . "--rev=")
					  (git . "")
					  (bazaar . "")
					  (subversion . "")
					  (cvs . ""))
  "mvc-default-diff-option-list"
  :type '(list (list
		(cons (const mercurial) (repeat string))
		(cons (const git) (repeat string))
		(cons (const bazaar) (repeat string))
		(cons (const subversion) (repeat string))
		(cons (const cvs) (repeat string))))
  :group 'mvc-variables)

(defcustom mvc-default-option-list-strict '((diff . ((mercurial . nil)
						     (git . nil)
						     (bazaar . nil)
						     (subversion . nil)
						     (cvs . nil)))
					    (add . ((mercurial . nil)
						    (git . nil)
						    (bazaar . nil)
						    (subversion . nil)
						    (cvs . nil)))
					    (annotate . ((mercurial . ("--user"
								       "--number"
								       "--changeset"
								       "--date"))
							 (git . nil)
							 (bazaar . nil)
							 (subversion . nil)
							 (cvs . nil)))
					    (revert . ((mercurial . nil)
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					    (remove . ((mercurial . nil)
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					    (rename . ((mercurial . nil)
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					    (commit . ((mercurial . nil)
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					    (status . ((mercurial . nil)
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					    (log . ((mercurial . ("--verbose"))
						    (git . ("--stat" "--stat-count=32" "--graph" "--decorate=full"))
						    (bazaar . ("--verbose"))
						    (subversion . ("--verbose"))
						    (cvs . nil))))
  "mvc-default-option-list-strict"
  :type '(list (cons (const diff) (list
				   (cons (const mercurial) (repeat string))
				   (cons (const git) (repeat string))
				   (cons (const bazaar) (repeat string))
				   (cons (const subversion) (repeat string))
				   (cons (const cvs) (repeat string))))
	       (cons (const add) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string))))
	       (cons (const annotate) (list
				       (cons (const mercurial) (repeat string))
				       (cons (const git) (repeat string))
				       (cons (const bazaar) (repeat string))
				       (cons (const subversion) (repeat string))
				       (cons (const cvs) (repeat string))))
	       (cons (const revert) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const remove) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const rename) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const commit) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const status) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const log) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string)))))
  :group 'mvc-variables)

(defcustom mvc-default-option-list-fast '((diff . ((mercurial . nil)
						   (git . nil)
						   (bazaar . nil)
						   (subversion . nil)
						   (cvs . nil)))
					  (add . ((mercurial . nil)
						  (git . nil)
						  (bazaar . nil)
						  (subversion . nil)
						  (cvs . nil)))
					  (annotate . ((mercurial . ("--user"
								     "--number"
								     "--changeset"
								     "--date"))
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					  (revert . ((mercurial . nil)
						     (git . nil)
						     (bazaar . nil)
						     (subversion . nil)
						     (cvs . nil)))
					  (remove . ((mercurial . nil)
						     (git . nil)
						     (bazaar . nil)
						     (subversion . nil)
						     (cvs . nil)))
					  (rename . ((mercurial . nil)
						     (git . nil)
						     (bazaar . nil)
						     (subversion . nil)
						     (cvs . nil)))
					  (commit . ((mercurial . nil)
						     (git . nil)
						     (bazaar . nil)
						     (subversion . nil)
						     (cvs . nil)))
					  (status . ((mercurial . nil)
						     (git . nil)
						     (bazaar . nil)
						     (subversion . nil)
						     (cvs . nil)))
					  (log . ((mercurial . ("--verbose"))
						  (git . ("--stat" "--stat-count=32" "--decorate=full"))
						  (bazaar . ("--verbose"))
						  (subversion . ("--verbose"))
						  (cvs . nil))))
  "mvc-default-option-list-fast"
  :type '(list (cons (const diff) (list
				   (cons (const mercurial) (repeat string))
				   (cons (const git) (repeat string))
				   (cons (const bazaar) (repeat string))
				   (cons (const subversion) (repeat string))
				   (cons (const cvs) (repeat string))))
	       (cons (const add) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string))))
	       (cons (const annotate) (list
				       (cons (const mercurial) (repeat string))
				       (cons (const git) (repeat string))
				       (cons (const bazaar) (repeat string))
				       (cons (const subversion) (repeat string))
				       (cons (const cvs) (repeat string))))
	       (cons (const revert) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const remove) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const rename) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const commit) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const status) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const log) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string)))))
  :group 'mvc-variables)

(defcustom mvc-mvc-default-option-list-strict '((diff . ((mercurial . nil)
							 (git . nil)
							 (bazaar . nil)
							 (subversion . nil)
							 (cvs . nil)))
						(add . ((mercurial . nil)
							(git . nil)
							(bazaar . nil)
							(subversion . nil)
							(cvs . nil)))
						(annotate . ((mercurial . nil)
							     (git . nil)
							     (bazaar . nil)
							     (subversion . nil)
							     (cvs . nil)))
						(revert . ((mercurial . nil)
							   (git . nil)
							   (bazaar . nil)
							   (subversion . nil)
							   (cvs . nil)))
						(remove . ((mercurial . nil)
							   (git . nil)
							   (bazaar . nil)
							   (subversion . nil)
							   (cvs . nil)))
						(rename . ((mercurial . nil)
							   (git . nil)
							   (bazaar . nil)
							   (subversion . nil)
							   (cvs . nil)))
						(commit . ((mercurial . nil)
							   (git . nil)
							   (bazaar . nil)
							   (subversion . nil)
							   (cvs . nil)))
						(status . ((mercurial . nil)
							   (git . nil)
							   (bazaar . nil)
							   (subversion . nil)
							   (cvs . nil)))
						(log . ((mercurial . nil)
							(git . nil)
							(bazaar . nil)
							(subversion . nil)
							(cvs . nil))))
  "mvc-mvc-default-option-list-strict"
  :type '(list (cons (const diff) (list
				   (cons (const mercurial) (repeat string))
				   (cons (const git) (repeat string))
				   (cons (const bazaar) (repeat string))
				   (cons (const subversion) (repeat string))
				   (cons (const cvs) (repeat string))))
	       (cons (const add) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string))))
	       (cons (const annotate) (list
				       (cons (const mercurial) (repeat string))
				       (cons (const git) (repeat string))
				       (cons (const bazaar) (repeat string))
				       (cons (const subversion) (repeat string))
				       (cons (const cvs) (repeat string))))
	       (cons (const revert) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const remove) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const rename) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const commit) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const status) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const log) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string)))))
  :group 'mvc-variables)

(defcustom mvc-mvc-default-option-list-fast '((diff . ((mercurial . nil)
						       (git . nil)
						       (bazaar . nil)
						       (subversion . nil)
						       (cvs . nil)))
					      (add . ((mercurial . nil)
						      (git . nil)
						      (bazaar . nil)
						      (subversion . nil)
						      (cvs . nil)))
					      (annotate . ((mercurial . nil)
							   (git . nil)
							   (bazaar . nil)
							   (subversion . nil)
							   (cvs . nil)))
					      (revert . ((mercurial . nil)
							 (git . nil)
							 (bazaar . nil)
							 (subversion . nil)
							 (cvs . nil)))
					      (remove . ((mercurial . nil)
							 (git . nil)
							 (bazaar . nil)
							 (subversion . nil)
							 (cvs . nil)))
					      (rename . ((mercurial . nil)
							 (git . nil)
							 (bazaar . nil)
							 (subversion . nil)
							 (cvs . nil)))
					      (commit . ((mercurial . nil)
							 (git . nil)
							 (bazaar . nil)
							 (subversion . nil)
							 (cvs . nil)))
					      ;; 巨大なプロジェクトや、ネットワークドライブなどで repository/working directory が遅い場合、
					      ;; 以下のオプションを付けると劇的にレスポンスが改善することがあります。
					      (status . ((mercurial . ("--disable-search-unknown" "--disable-search-unmodified"))
							 (git . ("--disable-search-unknown" "--disable-search-unmodified"))
							 (bazaar . ("--disable-search-unknown" "--disable-search-unmodified"))
							 (subversion . ("--disable-search-unknown" "--disable-search-unmodified"))
							 (cvs . ("--disable-search-unknown" "--disable-search-unmodified"))))
					      (log . ((mercurial . nil)
						      (git . nil)
						      (bazaar . nil)
						      (subversion . nil)
						      (cvs . nil))))
  "mvc-mvc-default-option-list-fast"
  :type '(list (cons (const diff) (list
				   (cons (const mercurial) (repeat string))
				   (cons (const git) (repeat string))
				   (cons (const bazaar) (repeat string))
				   (cons (const subversion) (repeat string))
				   (cons (const cvs) (repeat string))))
	       (cons (const add) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string))))
	       (cons (const annotate) (list
				       (cons (const mercurial) (repeat string))
				       (cons (const git) (repeat string))
				       (cons (const bazaar) (repeat string))
				       (cons (const subversion) (repeat string))
				       (cons (const cvs) (repeat string))))
	       (cons (const revert) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const remove) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const rename) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const commit) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const status) (list
				     (cons (const mercurial) (repeat string))
				     (cons (const git) (repeat string))
				     (cons (const bazaar) (repeat string))
				     (cons (const subversion) (repeat string))
				     (cons (const cvs) (repeat string))))
	       (cons (const log) (list
				  (cons (const mercurial) (repeat string))
				  (cons (const git) (repeat string))
				  (cons (const bazaar) (repeat string))
				  (cons (const subversion) (repeat string))
				  (cons (const cvs) (repeat string)))))
  :group 'mvc-variables)

(defcustom mvc-mvc-default-status-strict-p t
  "mvc-mvc-default-status-strict-p"
  :type 'boolean
  :group 'mvc-variables)

(defcustom mvc-default-log-limit "32"
  "mvc-default-log-limit"
  :type 'string
  :group 'mvc-variables)
(defcustom mvc-default-commit-message "no comment\n"
  "mvc-default-commit-message"
  :type 'string
  :group 'mvc-variables)

;; '((vcskey . (("表示用文字列"
;;               "説明文字列"
;;               function symbol))))
(defcustom mvc-default-especial-list
  '((mercurial . nil)
    (git . nil)
    (bazaar . nil)
    (subversion . (("   add svn:ignore"
		    "add mark file(s) to svn:ignore for current directory"
		    mvc-especial-mode-svn-add-ignore)
		   ("remove svn:ignore"
		    "remove mark file(s) from svn:ignore for current directory"
		    mvc-especial-mode-svn-remove-ignore)))
    (cvs . nil))
  "mvc-default-especial-list"
  :type '(list (cons (const mercurial) (repeat (list string string symbol)))
	       (cons (const git) (repeat (list string string symbol)))
	       (cons (const bazaar) (repeat (list string string symbol)))
	       (cons (const subversion) (repeat (list string string symbol)))
	       (cons (const cvs) (repeat (list string string symbol))))
  :group 'mvc-variables)

;; '("path regexp 0"
;;   "path regexp 1"
;;   "path regexp N")
;;
;; path regexp で指定された path では高速モードで status バッファを起動します。
;; ファイル数が多いプロジェクトで status の待ち時間が短かくなります。
;; 
;; 具体的には下記フラグが制御されます。
;; 
;;     - mvc-l-status-recursive-p が nil
;;     - mvc-l-status-strict-p が nil
;;
;; default-directory と比較するので、完全一致させる場合は末尾に "/" が
;; 必要なことに注意が必要です。
;;
;; なお recursive flag は以下の vcs とコマンドに対応しています。
;;
;;    - Subversion status
;;    - Subversion revert
;;    - Subversion commit
;;
(defcustom mvc-default-status-fast-directory-regexp-list
  '("/gimp/$"
    "/krita/$"
    "/gcc/$"
    "/gecko-dev/$")
  "mvc-default-status-fast-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

;; 
;; status-display-* は下記の順番で評価される
;; 
;; 1. グローバルな nil or t          mvc-default-status-display-*
;; 2. ディレクトリがマッチすれば nil mvc-default-status-display-*-nil-directory-regexp-list
;; 3. ディレクトリがマッチすれば t   mvc-default-status-display-*-t-directory-regexp-list
;;
;; 冗長だが、指定ディレクトリを add-to-list するだけで使える。
;; mvc-default-diff-option-list のような複雑な構造だと、ソースはシンプルになるが設定ファイルに書くには面倒。
;; 
(defcustom mvc-default-status-display-unknown-nil-directory-regexp-list
  nil
  "mvc-default-status-display-unknown-nil-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-unknown-t-directory-regexp-list
  nil
  "mvc-default-status-display-unknown-t-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-unmodified-nil-directory-regexp-list
  nil
  "mvc-default-status-display-unmodified-nil-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-unmodified-t-directory-regexp-list
  nil
  "mvc-default-status-display-unmodified-t-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-backup-nil-directory-regexp-list
  nil
  "mvc-default-status-display-backup-nil-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-backup-t-directory-regexp-list
  nil
  "mvc-default-status-display-backup-t-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-ignore-nil-directory-regexp-list
  nil
  "mvc-default-status-display-ignore-nil-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-ignore-t-directory-regexp-list
  nil
  "mvc-default-status-display-ignore-t-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-delete-nil-directory-regexp-list
  nil
  "mvc-default-status-display-delete-nil-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-status-display-delete-t-directory-regexp-list
  nil
  "mvc-default-status-display-delete-t-directory-regexp-list"
  :type '(repeat string)
  :group 'mvc-variables)

(defcustom mvc-default-cheat-sheet-history
  '((mercurial . ("%mvc branches"
		  "%mvc glog --limit=10"
		  "%mvc heads"
		  "%mvc branch"
		  "%mvc tags"
		  "%mvc merge "
		  "%mvc commit -m ''"
		  "%mvc unshelve"
		  "%mvc shelve"
		  "%mvc forget %files"
		  "%mvc forget %file"
		  "%mvc backout --merge --logfile=%commitlog"
		  "%program tag"
		  "%program tag --rev="
		  "echo %files"))
    (git . ("gitk --all"
	    "%program branch"
	    "%program branch -r"
	    "%program branch -a"
	    "%program show-branch"
	    "%program stash list"
	    "%program status"
	    "%program checkout "
	    "#@no-return-window"
	    "%program log --graph --decorate=full --stat -n 8 "
	    "#@elisp-eval"
	    "(message \"test\")"
	    "%program show %files"
	    "%program checkout %files"
	    "%program commit --file=%commitlog"
	    "%program commit -m 'merge'"
	    "%program rebase -i"
	    "%program reset --soft "
	    "%program reset --hard FETCH_HEAD"))
    (bazaar . ("echo %program %files"))
    (subversion . ("echo %program %files"))
    (cvs . ("")))
  "mvc-cheat-sheet 用のヒストリ初期値です。
よく使うコマンドを指定しておくと便利です。
以下の文字が特殊な意味を持ちます。

    - %mvc         mvc コマンド経由でプログラム名を起動するよう変換されます
    - %program     hg や git などのプログラム名に変換されます
    - %file        カーソルが指しているファイル名に変換されます
    - %files       カーソルが指しているファイルまたはマークされたファイル名群に変換されます
    - %commitlog   mvc-commitlog-mode を起動し、出力テンポラリファイルに変換されます
"
  :type '(list (cons (const mercurial) (repeat string))
	       (cons (const git) (repeat string))
	       (cons (const bazaar) (repeat string))
	       (cons (const subversion) (repeat string))
	       (cons (const cvs) (repeat string)))
  :group 'mvc-variables)

(defcustom mvc-default-cheat-sheet-directory "~/.emacs.d/.mvc.cheat-sheet/"
  "mvc-default-cheat-sheet-directory"
  :type 'string
  :group 'mvc-variables)

(defcustom mvc-default-use-emacs-client t
  "mvc-default-use-emacs-client"
  :type 'boolean
  :group 'mvc-variables)




(defface mvc-face-tab-active
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque1" :bold t :box (:line-width 2 :style released-button)))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray50" :bold t :box (:line-width 2 :style released-button))))
  "tab active"
  :group 'mvc-faces)
(defface mvc-face-tab-inactive
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque4" :bold t :box (:line-width 2 :style released-button)))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray30" :bold t :box (:line-width 2 :style released-button))))
  "tab inactive"
  :group 'mvc-faces)

(defface mvc-face-button-active
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque1" :bold t :box (:line-width 2 :style released-button)))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray50" :bold t :box (:line-width 2 :style released-button))))
  "button active"
  :group 'mvc-faces)
(defface mvc-face-button-inactive
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque4" :bold t :box (:line-width 2 :style released-button)))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray20" :bold t :box (:line-width 2 :style released-button))))
  "button inactive"
  :group 'mvc-faces)

(defface mvc-face-toggle-button-active
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque3" :bold t :box (:line-width 3 :style pressed-button)))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray20" :bold t :box (:line-width 3 :style pressed-button))))
  "toggle button active"
  :group 'mvc-faces)
(defface mvc-face-toggle-button-inactive
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque2" :bold t :box (:line-width 3 :style released-button)))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray50" :bold t :box (:line-width 3 :style released-button))))
  "toggle button inactive"
  :group 'mvc-faces)

(defface mvc-face-default-directory
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque1"))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray20")))
  "default-directory"
  :group 'mvc-faces)

(defface mvc-face-status-footer
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "bisque1"))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "gray20")))
  "status footer"
  :group 'mvc-faces)
(defface mvc-face-status-directory
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "darkblue" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "CadetBlue1" :bold t)))
  "status directory"
  :group 'mvc-faces)
(defface mvc-face-status-modified
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "darkgreen" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "SpringGreen3" :bold t)))
  "status modified"
  :group 'mvc-faces)

(defface mvc-face-commit-headline
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "darkblue" :bold t :underline t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "blue" :bold t :underline t)))
  "commit headline"
  :group 'mvc-faces)
(defface mvc-face-commit-fatal
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "red" :background "dimgray" :bold t :underline t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "red" :background "dimgray" :bold t :underline t)))
  "commit fatal"
  :group 'mvc-faces)
(defface mvc-face-commit-warning
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "darkred" :bold t :underline t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "red" :bold t :underline t)))
  "commit warning"
  :group 'mvc-faces)
(defface mvc-face-commit-information
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :bold t)))
  "commit information"
  :group 'mvc-faces)
(defface mvc-face-commit-git-commit-underline
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "beige" :bold t :underline t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "black" :background "beige" :bold t :underline t)))
  "commit information"
  :group 'mvc-faces)
(defface mvc-face-commit-git-commit
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "black" :background "beige" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "black" :background "beige" :bold t)))
  "commit information"
  :group 'mvc-faces)

(defface mvc-face-animation-timer-0
  '((((type x w32 mac ns) (class color)) (:foreground "#000f0f" :background "lightgray" :bold t)))
  "animation timer 0"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-1
  '((((type x w32 mac ns) (class color)) (:foreground "#003f00" :background "lightgray" :bold t)))
  "animation timer 1"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-2
  '((((type x w32 mac ns) (class color)) (:foreground "#007f00" :background "lightgray" :bold t)))
  "animation timer 2"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-3
  '((((type x w32 mac ns) (class color)) (:foreground "#003f00" :background "lightgray" :bold t)))
  "animation timer 3"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-4
  '((((type x w32 mac ns) (class color)) (:foreground "#000f0f" :background "lightgray" :bold t)))
  "animation timer 4"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-5
  '((((type x w32 mac ns) (class color)) (:foreground "#00007f" :background "lightgray" :bold t)))
  "animation timer 5"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-6
  '((((type x w32 mac ns) (class color)) (:foreground "#0000ff" :background "lightgray" :bold t)))
  "animation timer 6"
  :group 'mvc-faces)
(defface mvc-face-animation-timer-7
  '((((type x w32 mac ns) (class color)) (:foreground "#00007f" :background "lightgray" :bold t)))
  "animation timer 7"
  :group 'mvc-faces)

(defface mvc-face-log-revision
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "#00007f" :background "lightgray" :bold t :underline t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "#00007f" :background "gray" :bold t :underline t)))
  "log revision"
  :group 'mvc-faces)

(defface mvc-face-especial-path
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "darkblue" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "blue" :bold t)))
  "especial path"
  :group 'mvc-faces)

(defface mvc-face-branch-default
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "darkblue" :background "tan" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "blue" :background "tan" :bold t)))
  "branch default"
  :group 'mvc-faces)
(defface mvc-face-branch-master
  '((((type x w32 mac ns) (class color) (background light)) (:foreground "white" :background "red3" :bold t))
    (((type x w32 mac ns) (class color) (background dark)) (:foreground "white" :background "red3" :bold t)))
  "branch default"
  :group 'mvc-faces)




(defconst mvc-program-display-name '((mercurial . "hg")
				     (git . "git")
				     (bazaar . "bazaar")
				     (subversion . "svn")
				     (cvs . "cvs")
				     "display name"))
(defconst mvc-mvc-program-name "mvc")
(defconst mvc-program-name '((mercurial . "hg")
			     (git . "git")
			     (bazaar . "bzr")
			     (subversion . "svn")
			     (cvs . "cvs")
			     "program name"))

(defconst mvc-control-directory-name '((mercurial . ".hg")
				       (git . ".git")
				       (bazaar . ".bzr")
				       (subversion . ".svn")
				       (cvs . "CVS")
				       "control directory name"))

(defconst mvc-mode-name-status "mvc status")
(defconst mvc-mode-name-commitlog "mvc commitlog")
(defconst mvc-mode-name-log "mvc log")
(defconst mvc-mode-name-especial "mvc especial")
(defconst mvc-mode-name-especial-commit "mvc especial-commit")
(defconst mvc-mode-name-cheat-sheet "mvc cheat-sheet")
(defconst mvc-mode-name-cheat-sheet-process "mvc cheat-sheet-process")

(defconst mvc-running-header-decoration-0 "**")
(defconst mvc-running-header-decoration-1 "--")
(defconst mvc-running-header-running "running")
(defconst mvc-running-header-head (concat mvc-running-header-decoration-0 " "))
(defconst mvc-running-header-tail (concat " " mvc-running-header-running))
(defconst mvc-message-process-already-running "process already running!")
(defconst mvc-header-string-time "--- --- -- --:--:-- ----")

(defvar mvc-status-buffer-name-base-hash (make-hash-table :test 'equal))
(defvar mvc-status-buffer-list nil)

(defvar mvc-program-list-cache-hash (make-hash-table :test 'equal))
(defvar mvc-cheat-sheet-tmpfile-hash (make-hash-table :test 'equal))




;;; mvc-status-mode-map
(defvar mvc-status-mode-map (make-sparse-keymap))

(define-key mvc-status-mode-map "+" 'mvc-status-mode-mkdir)
(define-key mvc-status-mode-map "f" 'mvc-status-mode-find-file)
(define-key mvc-status-mode-map "v" 'mvc-status-mode-view-file)
(define-key mvc-status-mode-map "n" 'mvc-status-mode-next)
(define-key mvc-status-mode-map "p" 'mvc-status-mode-previous)
(define-key mvc-status-mode-map "\C-n" 'mvc-status-mode-next)
(define-key mvc-status-mode-map "\C-p" 'mvc-status-mode-previous)
(define-key mvc-status-mode-map "\C-i" 'mvc-status-mode-next-button)
(define-key mvc-status-mode-map "\M-\C-i" 'mvc-status-mode-next-status)
(define-key mvc-status-mode-map (kbd "M-C-S-i") 'mvc-status-mode-previous-status)
(define-key mvc-status-mode-map "\M-." 'mvc-status-mode-next-status)
(define-key mvc-status-mode-map "\M-," 'mvc-status-mode-previous-status)

(define-key mvc-status-mode-map "\C-c?" 'mvc-status-mode-toggle-display-unknown)
(define-key mvc-status-mode-map "\C-c_" 'mvc-status-mode-toggle-display-unmodified)
(define-key mvc-status-mode-map "\C-c~" 'mvc-status-mode-toggle-display-backup)
(define-key mvc-status-mode-map "\C-ci" 'mvc-status-mode-toggle-display-ignore)
(define-key mvc-status-mode-map "m" 'mvc-status-mode-mark)
(define-key mvc-status-mode-map "u" 'mvc-status-mode-unmark)
(define-key mvc-status-mode-map "*!" 'mvc-status-mode-unmark-all)
(define-key mvc-status-mode-map "*?" 'mvc-status-mode-mark-unknown)
(define-key mvc-status-mode-map "*A" 'mvc-status-mode-mark-add)
(define-key mvc-status-mode-map "*D" 'mvc-status-mode-mark-remove)
(define-key mvc-status-mode-map "*M" 'mvc-status-mode-mark-modified)
(define-key mvc-status-mode-map "*R" 'mvc-status-mode-mark-path-regexp)
(define-key mvc-status-mode-map "%m" 'mvc-status-mode-mark-path-regexp)

(define-key mvc-status-mode-map "<" 'mvc-status-mode-pull)
(define-key mvc-status-mode-map ">" 'mvc-status-mode-push)
(define-key mvc-status-mode-map "\M-<" 'mvc-status-mode-beginning-of-list)
(define-key mvc-status-mode-map "\M->" 'mvc-status-mode-end-of-list)
(define-key mvc-status-mode-map "a" 'mvc-status-mode-add)
(define-key mvc-status-mode-map "b" 'mvc-status-mode-annotate)
(define-key mvc-status-mode-map "c" 'mvc-status-mode-commit)
(define-key mvc-status-mode-map "g" 'mvc-status-mode-status)
(define-key mvc-status-mode-map "l" 'mvc-status-mode-log)
(define-key mvc-status-mode-map "r" 'mvc-status-mode-revert)
(define-key mvc-status-mode-map "s" 'mvc-status-mode-status)
(define-key mvc-status-mode-map "D" 'mvc-status-mode-remove)
(define-key mvc-status-mode-map "Q" 'mvc-status-mode-quit)
(define-key mvc-status-mode-map "R" 'mvc-status-mode-rename)
(define-key mvc-status-mode-map "U" 'mvc-status-mode-update)
(define-key mvc-status-mode-map "\M-u" 'mvc-status-mode-update)
(define-key mvc-status-mode-map "=" 'mvc-status-mode-diff-only-current)
(define-key mvc-status-mode-map (kbd "C-=") 'mvc-status-mode-diff-current-or-mark)
(define-key mvc-status-mode-map (kbd "M-C-=") 'mvc-status-mode-ediff-only-current)
(define-key mvc-status-mode-map "S" 'mvc-status-mode-especial)
(define-key mvc-status-mode-map "!" 'mvc-status-mode-cheat-sheet)
(define-key mvc-status-mode-map "\C-g" 'mvc-status-mode-cancel-process)
(define-key mvc-status-mode-map "\C-c\C-k" 'mvc-status-mode-cancel-process)


;;; mvc-commitlog-mode-map
(defvar mvc-commitlog-mode-map (make-sparse-keymap))

(define-key mvc-commitlog-mode-map "\C-c\C-c" 'mvc-commitlog-mode-done)


;;; mvc-log-mode-map

(defvar mvc-log-mode-map (make-sparse-keymap))

(define-key mvc-log-mode-map "\C-i" 'mvc-log-mode-next)
(define-key mvc-log-mode-map "n" 'mvc-log-mode-next)
(define-key mvc-log-mode-map "p" 'mvc-log-mode-previous)
(define-key mvc-log-mode-map " " 'scroll-up)
(define-key mvc-log-mode-map "\C-m" 'mvc-log-mode-return)
(define-key mvc-log-mode-map "=" 'mvc-log-mode-diff)
(define-key mvc-log-mode-map "!" 'mvc-log-mode-cheat-sheet)
(define-key mvc-log-mode-map "\M-." 'mvc-log-mode-status-mode-next-status)
(define-key mvc-log-mode-map "\M-," 'mvc-log-mode-status-mode-previous-status)


;;; mvc-especial-mode-map

(defvar mvc-especial-mode-map (make-sparse-keymap))

(define-key mvc-especial-mode-map "\C-i" 'mvc-especial-mode-next)
(define-key mvc-especial-mode-map "g" 'mvc-especial-mode-draw)
(define-key mvc-especial-mode-map "n" 'mvc-especial-mode-next)
(define-key mvc-especial-mode-map "p" 'mvc-especial-mode-previous)
(define-key mvc-especial-mode-map "s" 'mvc-especial-mode-draw)


;;; mvc-especial-commit-mode-map

(defvar mvc-especial-commit-mode-map (make-sparse-keymap))

(define-key mvc-especial-commit-mode-map "\C-c\C-c" 'mvc-especial-commit-mode-done)


;;; mvc-cheat-sheet-mode-map

(defvar mvc-cheat-sheet-mode-map (make-sparse-keymap))

(define-key mvc-cheat-sheet-mode-map "\C-c\C-c" 'mvc-cheat-sheet-mode-run)
(define-key mvc-cheat-sheet-mode-map "\M-;" 'mvc-cheat-sheet-mode-comment)
(define-key mvc-cheat-sheet-mode-map "\M-\C-i" 'mvc-cheat-sheet-mode-next-status)
(define-key mvc-cheat-sheet-mode-map (kbd "M-C-S-i") 'mvc-cheat-sheet-mode-previous-status)
(define-key mvc-cheat-sheet-mode-map "\M-." 'mvc-cheat-sheet-mode-next-status)
(define-key mvc-cheat-sheet-mode-map "\M-," 'mvc-cheat-sheet-mode-previous-status)
(define-key mvc-cheat-sheet-mode-map "\C-g" 'mvc-cheat-sheet-mode-cancel-process)
(define-key mvc-cheat-sheet-mode-map "\C-c\C-k" 'mvc-cheat-sheet-mode-cancel-process)


;;; mvc-cheat-sheet-process-mode-map

(defvar mvc-cheat-sheet-process-mode-map (make-sparse-keymap))

(define-key mvc-cheat-sheet-process-mode-map "\C-g" 'mvc-cheat-sheet-process-mode-cancel-process)
(define-key mvc-cheat-sheet-process-mode-map "\C-c\C-k" 'mvc-cheat-sheet-process-mode-cancel-process)




;;; mvc utilities

(defun mvc-search-control-directory (program)
  (catch 'outer
    (let ((current-dir (expand-file-name "."))
	  (control-dir (cdr (assq program mvc-control-directory-name)))
	  full-path-dir)
      (while t
	(when (file-symlink-p current-dir)
	  (setq current-dir (file-symlink-p current-dir)))
	(setq full-path-dir (concat current-dir "/" control-dir))
	(if (file-directory-p full-path-dir)
	    (progn
	      (throw 'outer full-path-dir))
	  (if (string-match "\\(.+\\)/.+" current-dir)
	      (setq current-dir (match-string 1 current-dir))
	    (throw 'outer nil)))))))

(defun mvc-clear-program-list-cache (clear-all-p)
  "バージョンコントロールプログラムに関するキャッシュをクリアします。
clear-all が nil ならばカレントディレクトリのキャッシュをクリアし、
Non-nil ならば全てのキャッシュをクリアします。
mvc-is-exist-program-hash は常にクリアされます。"
  (if clear-all-p
      (clrhash mvc-program-list-cache-hash)
    (puthash (expand-file-name default-directory) nil mvc-program-list-cache-hash)))

(defun mvc-get-current-program-list ()
  "カレントディレクトリのバージョンコントロールプログラムに対応す
るシンボルのリストを返します。プログラムは
mvc-default-program-search-order-list の順に探索されますが、
mvc-default-program-search-concurrent が nil ならば最初の 1 つが見
付かった時点で探索を打ち切ります。プログラムが不明な場合は nil を
返します。以下のプログラムを認識します。

- 'mercurial
- 'git
- 'bazaar
- 'subversion
- 'cvs

初回の呼び出しはディレクトリをたどるため、少しだけ時間がかかること
がありますが、この結果はキャッシュされるため、次以降の呼び出しは高
速に実行されます。キャッシュは関数 mvc-clear-program-list-cache で
クリアすることができます。
"
  (let ((name-list (gethash (expand-file-name default-directory) mvc-program-list-cache-hash)))
    (unless name-list
      (catch 'found
	(mapc #'(lambda (program)
		  (cond ((eq program 'mercurial)
			 (when (mvc-search-control-directory 'mercurial)
			   (setq name-list (append name-list (list 'mercurial)))
			   (unless mvc-default-program-search-concurrent
			     (throw 'found nil))))
			((eq program 'git)
			 (when (mvc-search-control-directory 'git)
			   (setq name-list (append name-list (list 'git)))
			   (unless mvc-default-program-search-concurrent
			     (throw 'found nil))))
			((eq program 'bazaar)
			 (when (mvc-search-control-directory 'bazaar)
			   (setq name-list (append name-list (list 'bazaar)))
			   (unless mvc-default-program-search-concurrent
			     (throw 'found nil))))
			((eq program 'subversion)
			 (when (file-exists-p ".svn")
			   (setq name-list (append name-list (list 'subversion)))
			   (unless mvc-default-program-search-concurrent
			     (throw 'found nil))))
			((eq program 'cvs)
			 (when (file-exists-p "CVS")
			   (setq name-list (append name-list (list 'cvs)))
			   (unless mvc-default-program-search-concurrent
			     (throw 'found nil))))
			(t
			 (error "Illegal mvc-default-program-search-order-list"))))
	      mvc-default-program-search-order-list))
      (puthash (expand-file-name default-directory) name-list mvc-program-list-cache-hash))
    name-list))

(defun mvc-create-buffer-name (prefix initial-directory)
  (let* ((key (expand-file-name initial-directory))
	 (base (gethash key mvc-status-buffer-name-base-hash)))
    (unless base
      (string-match "/\\([^/]+\\)/$" key)
      (setq base (match-string 1 key))
      (setq base (substring (generate-new-buffer-name (concat prefix base)) (length prefix)))
      (puthash key base mvc-status-buffer-name-base-hash))
    (concat prefix base)))

(defun mvc-call-process-and-set-buffer-temporary (status-buffer
						  program
						  option-list)
  (let (temporary-process-buffer-name)
    (with-current-buffer status-buffer
      (setq temporary-process-buffer-name (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))))
    (set-buffer (get-buffer-create temporary-process-buffer-name))
    (setq buffer-undo-list t)
    (setq buffer-read-only nil)
    (erase-buffer)
    (apply 'call-process program nil t nil option-list)))

(defun mvc-show-call-process-temporary-result (status-buffer &optional buffer-active-p)
  (let (result-buffer
	temporary-process-buffer-name)
    (with-current-buffer status-buffer
      (setq result-buffer (get-buffer-create (cdr (assq 'result mvc-l-status-buffer-name-list))))
      (setq temporary-process-buffer-name (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))))
    (unless (get-buffer-window result-buffer)
      (split-window))
    (if buffer-active-p
	(pop-to-buffer result-buffer)
      (display-buffer result-buffer))
    (with-current-buffer result-buffer
      (setq buffer-undo-list t)
      (setq buffer-read-only nil)
      (erase-buffer)
      (insert-buffer-substring temporary-process-buffer-name)
      (kill-buffer temporary-process-buffer-name)
      (setq buffer-read-only t))))

(defun mvc-insert-with-face (string face)
  (if mvc-default-use-color
      (let ((start (point)))
	(insert string)
	(set-text-properties start
			     (+ start (length string))
			     (list 'face face)))
    (insert string)))

(defun mvc-get-default-option-list (&optional status-buffer)
  (if status-buffer
      (with-current-buffer status-buffer
	(if mvc-l-status-strict-p
	    mvc-default-option-list-strict
	  mvc-default-option-list-fast))
    (if mvc-l-status-strict-p
	mvc-default-option-list-strict
      mvc-default-option-list-fast)))

(defun mvc-get-mvc-default-option-list (&optional status-buffer)
  (if status-buffer
      (with-current-buffer status-buffer
	(if mvc-l-status-strict-p
	    mvc-mvc-default-option-list-strict
	  mvc-mvc-default-option-list-fast))
    (if mvc-l-status-strict-p
	mvc-mvc-default-option-list-strict
      mvc-mvc-default-option-list-fast)))




;;; mvc-status
(defun mvc-status (initial-directory)
  (interactive "Ddirectory: ")

  (unless (string-match "/$" initial-directory)
    (setq initial-directory (concat initial-directory "/")))
  (if (file-directory-p initial-directory)
      (let (initial-program-list)
	(let ((default-directory initial-directory))
	  (setq initial-program-list (mvc-get-current-program-list)))
	(if initial-program-list
	    (let (first-buffer)
	      (mapc #'(lambda (program)
			(let ((buffer (mvc-create-buffer-name (concat "*mvc-"
								      (cdr (assq program mvc-program-display-name))
								      "-status*")
							      initial-directory)))
			  (if (get-buffer buffer)
			      (progn
				(set-buffer buffer)
				(mvc-async-status))
			    (set-buffer (get-buffer-create buffer))
			    (setq default-directory initial-directory)
			    (setq mvc-status-buffer-list (cons (current-buffer) mvc-status-buffer-list))
			    (setq buffer-read-only t)
			    (mvc-async-status program)))
			(unless first-buffer
			  (setq first-buffer (current-buffer))))
		    initial-program-list)
	      (switch-to-buffer first-buffer))
	  (message "mvc.el : UNKNOWN VCS!")))
    (message "mvc.el : %s is not directory!" initial-directory)))

(defun mvc-status-async-p ()
  mvc-l-status-process-process)

(defun mvc-status-get-current-program-option-list-log (option-list prefix-argument)
  (let (result)
    (if prefix-argument
	(setq result (format "--limit=%d" (prefix-numeric-value prefix-argument)))
      (setq result (concat "--limit=" mvc-default-log-limit)))
    (setq result (append option-list (list result)))))

(defun mvc-status-get-current-program-option-list-diff (option-list prefix-argument)
  (cond ((and (>= mvc-l-status-file-name-list-git-stage-count 1)
	      (>= mvc-l-status-file-name-list-working-directory-count 1))
	 (message "warning: run diff working directory (mark stage and working directory)"))
	((>= mvc-l-status-file-name-list-git-stage-count 1)
	 (setcdr option-list (cons "HEAD" (cdr option-list))))
	((>= mvc-l-status-file-name-list-working-directory-count 1)
	 ))
  (if prefix-argument
      ;; FIXME!
      ;; そのうちここで適切なヒストリを作ってやる
      ;; mvc --get-revision-history みたいなのでいいかな?
      ;; (append option-list (list (concat "--revision="
      ;; 					(completing-read
      ;; 					 "--revision: "
      ;; 					 '("-3" "-2")
      ;; 					 nil
      ;; 					 nil
      ;; 					 ""))))
      (append option-list (split-string (completing-read
					 "revision: "
					 '("-3" "-2")
					 nil
					 nil
					 (if mvc-l-status-diff-paramter
					     mvc-l-status-diff-paramter
					   (cdr (assq mvc-l-status-program mvc-default-diff-option-list))))))
    option-list))

(defun mvc-status-get-current-program-option-list-commit (option-list temporary-file-name)
  (if temporary-file-name
      (append option-list (list (concat "--logfile=" temporary-file-name)))
    option-list))

(defun mvc-status-get-current-program-option-list-status (option-list)
  (cond ((eq mvc-l-status-program 'subversion)
	 (if mvc-l-status-recursive-p
	     option-list
	   ;; (append option-list (list "--depth=immediates"))
	   (append option-list (list "--non-recursive"))))
	((eq mvc-l-status-program 'mercurial)
	 (append option-list (list ".")))
	((or (eq mvc-l-status-program 'git)
	     (eq mvc-l-status-program 'bazaar)
	     (eq mvc-l-status-program 'cvs))
	 option-list)
	(t
	 (message "UNKNOWN PROGRAM!")
	 nil)))

(defun mvc-status-get-current-program-option-list-revert (option-list)
  (when (eq mvc-l-status-program 'git)
    (cond ((>= mvc-l-status-file-name-list-git-rename-count 1)
	   (when (not (= mvc-l-status-file-name-list-git-rename-count mvc-l-status-file-name-list-git-stage-count))
	     (error "%s" "error: revert rename failed (You can mark only renamed files)"))
	   (setq option-list (list "mvcautorevert")))
	  ((and (>= mvc-l-status-file-name-list-git-stage-count 1)
		(>= mvc-l-status-file-name-list-working-directory-count 1))
	   (message "warning: run revert working directory (mark stage and working directory)"))
	  ((>= mvc-l-status-file-name-list-git-stage-count 1)
	   (setq option-list (list "reset" "HEAD" "--")))
	  ((>= mvc-l-status-file-name-list-working-directory-count 1)
	   (setq option-list (list "checkout" "HEAD" "--")))))
  option-list)

(defun mvc-status-get-current-program-option-list (command &optional argument)
  "command と argument に従い command option-list.. を返します。

* argument
'log (argument(prefix-argument):表示数)
'diff (argument(prefix-argument):Non-nil の場合内部で completing-read することに注意)
'commit (argument(string):テンポラリログファイル名)"
  (let ((option-list (append (list (symbol-name command))
			     (cdr (assq mvc-l-status-program
					(cdr (assq command (mvc-get-default-option-list))))))))
    (cond ((eq command 'log)
	   (mvc-status-get-current-program-option-list-log option-list argument))
	  ((eq command 'diff)
	   (mvc-status-get-current-program-option-list-diff option-list argument))
	  ((eq command 'commit)
	   (mvc-status-get-current-program-option-list-commit option-list argument))
	  ((eq command 'status)
	   (mvc-status-get-current-program-option-list-status option-list))
	  ((eq command 'revert)
	   (mvc-status-get-current-program-option-list-revert option-list))
	  (t
	   option-list))))

(defun mvc-status-insert-button (label function)
  (let ((map (copy-keymap mvc-status-mode-map))
	(start (point)))
    (define-key map [mouse-1] function)
    (define-key map "\C-m" function)
    (mvc-insert-with-face label 'mvc-face-button-active)
    (put-text-property start (point) 'local-map map)))

(defun mvc-status-insert-toggle-button (flag label-true label-false function)
  (let ((map (copy-keymap mvc-status-mode-map))
	(start (point)))
    (define-key map [mouse-1] function)
    (define-key map "\C-m" function)
    (if flag
	(mvc-insert-with-face label-true 'mvc-face-toggle-button-active)
      (mvc-insert-with-face label-false 'mvc-face-toggle-button-inactive))
    (put-text-property start (point) 'local-map map)))

(defun mvc-status-update-header-line-only-display (update-string status-buffer)
  (when mvc-default-use-tab
    (when (or (not status-buffer)
	      (get-buffer-window status-buffer))
      (mapc #'(lambda (b)
		(with-current-buffer b
		  (setq header-line-format nil)
		  (mapc #'(lambda (a)
			    (let ((map (make-sparse-keymap))
				  tmp)
			      (funcall 'define-key map [header-line mouse-1]
				       `(lambda ()
					  (interactive)
					  (switch-to-buffer ,a)))
			      (with-current-buffer a
				(setq tmp (substring (buffer-name a) (length (cdr (assq 'status-base mvc-l-status-buffer-name-list))))))
			      (set-text-properties 0
						   (length tmp)
						   (list 'face
							 (if (eq a b)
							     'mvc-face-tab-active
							   'mvc-face-tab-inactive)
							 'local-map
							 map)
						   tmp)
			      (setq header-line-format (cons tmp header-line-format))
			      (setq header-line-format (cons " " header-line-format))))
			mvc-status-buffer-list)
		  (when (and (boundp 'mvc-l-status-branch-name)
			     mvc-l-status-branch-name)
		    (let ((branch-name (concat " branch:" mvc-l-status-branch-name)))
		      (if (string= mvc-l-status-branch-name "master")
			  (set-text-properties 8 (length branch-name) '(face mvc-face-branch-master) branch-name)
			(set-text-properties 8 (length branch-name) '(face mvc-face-branch-default) branch-name))
		      (setq header-line-format (append header-line-format (list (concat " " branch-name))))))
		  (when (and update-string
			     (eq b status-buffer))
		    (setq header-line-format (append header-line-format (list (concat " " update-string)))))))
	    mvc-status-buffer-list))))

(defun mvc-status-update-header-line ()
  (mvc-status-update-header-line-only-display nil nil))

(defun mvc-status-kill-buffer-hook ()
  (when (member (current-buffer) mvc-status-buffer-list)
    (setq mvc-status-buffer-list (delete (current-buffer) mvc-status-buffer-list))
    (puthash (expand-file-name default-directory) nil mvc-status-buffer-name-base-hash)
    (mvc-status-update-header-line)

    (when mvc-default-use-animation-timer
      (cancel-timer mvc-l-status-timer)
      (setq mvc-l-status-timer nil))
    (when mvc-l-status-process-process
      (delete-process (cdr (assq 'process-async mvc-l-status-buffer-name-list)))
      (setq mvc-l-status-process-process nil))))

(defun mvc-status-timer-function-redraw ()
  (when mvc-default-use-tab
  ;; なんでもいいからバッファを更新してやると header-line-format が更新
  ;; されるみたいなので、ここでバッファを更新。
    (with-current-buffer (get-buffer-create " *mvc-redraw-dummy*")
      (setq buffer-undo-list t)
      (insert "0\n")
      (when (< (% (random t) 100) 10)
	(erase-buffer)))))

(defun mvc-status-timer-function (buffer)
  (when (buffer-name buffer)
    (with-current-buffer buffer
      (let ((cheat-sheet-processes mvc-l-status-cheat-sheet-processes)
	    (cheat-sheet-bufname (replace-regexp-in-string "-status\\*" "-cheat-sheet*" (buffer-name buffer))))
	(if mvc-l-status-process-process
	    (let (decoration
		  (tmp (concat mvc-running-header-running))
		  (i (% (lsh mvc-l-status-timer-counter -1) (length mvc-running-header-running))))
	      (setq decoration (if (= (logand 1 i) 0)
				   mvc-running-header-decoration-0
				 mvc-running-header-decoration-1))
	      (store-substring tmp
			       i
			       (substring (upcase tmp) i (+ i 1)))
	      (let ((update-string (concat decoration
					   " " mvc-l-status-program-name " "
					   mvc-l-status-process-last-command
					   " "
					   tmp)))
		(set-text-properties 0
				     (length update-string)
				     (list 'face
					   (nth (% mvc-l-status-timer-counter 8)
						'(mvc-face-animation-timer-0
						  mvc-face-animation-timer-1
						  mvc-face-animation-timer-2
						  mvc-face-animation-timer-3
						  mvc-face-animation-timer-4
						  mvc-face-animation-timer-5
						  mvc-face-animation-timer-6
						  mvc-face-animation-timer-7)))
				     update-string)
		(let (tail-string start max)
		  (with-current-buffer mvc-l-status-process-buffer-name
		    (setq max (point-max))
		    (goto-char max)
		    (forward-line -1)
		    (setq start (point))
		    (end-of-line)
		    (setq tail-string (format "%8d:%s" max (buffer-substring start (point)))))
		  (when (not (eq mvc-l-status-timer-last-point max))
		    (setq mvc-l-status-timer-last-point max)
		    (setq update-string (concat update-string " " tail-string))))
		(mvc-status-update-header-line-only-display update-string buffer)
		(setq mode-line-process (concat " async" (format " %d" cheat-sheet-processes)))
		(when (get-buffer cheat-sheet-bufname)
		  (with-current-buffer cheat-sheet-bufname
		    (setq mode-line-process (concat " async" (format " %d" cheat-sheet-processes)))))
		(unless (string= mvc-l-status-timer-last-mode-line-string mode-line-process)
		  (setq mvc-l-status-timer-last-mode-line-string mode-line-process)
		  (force-mode-line-update))
		(when (get-buffer-window buffer)
		  (mvc-status-timer-function-redraw)))
	      (setq mvc-l-status-timer-counter (1+ mvc-l-status-timer-counter))
	      (when (> mvc-l-status-timer-counter 65535)
		(setq mvc-l-status-timer-counter 0)))
	  (let ((branch-name mvc-l-status-branch-name))
	    (setq mode-line-process (format " %d" cheat-sheet-processes))
	    (setq mode-name (concat mvc-mode-name-status " " branch-name))
	    (unless (string= mvc-l-status-timer-last-mode-line-string mode-line-process)
	      (setq mvc-l-status-timer-last-mode-line-string mode-line-process)
	      (setq mvc-l-status-timer-counter 0)
	      (when (get-buffer cheat-sheet-bufname)
		(with-current-buffer cheat-sheet-bufname
		  (setq mode-line-process (format " %d" cheat-sheet-processes))
		  (setq mode-name (concat mvc-mode-name-cheat-sheet " " branch-name))))
	      (force-mode-line-update)
	      (when (get-buffer cheat-sheet-bufname)
		(with-current-buffer cheat-sheet-bufname
		  (force-mode-line-update)))
	      (mvc-status-timer-function-redraw))))))))

(defun mvc-status-beginning-of-list ()
  (goto-char mvc-l-status-file-list-begin-point))

(defun mvc-status-end-of-list ()
  (let (end-point)
    (save-excursion
      (goto-char mvc-l-status-file-list-end-point)
      (beginning-of-line)
      (setq end-point (point)))
    (if (>= (point) end-point)
	(progn
	  (goto-char (point-max))
	  (forward-line -1))
      (goto-char end-point))))

;; 現在のバッファのカレント行を文字列として返します。無効な行ならば
;; nil を返します。
(defun mvc-status-get-current-line-string ()
  (if mvc-l-status-ready-p
      (save-excursion
	(let (current-start)
	  (beginning-of-line)
	  (setq current-start (point))
	  (if (or (< current-start mvc-l-status-file-list-begin-point)
		  (> current-start mvc-l-status-file-list-end-point))
	      nil
	    (goto-char current-start)
	    (end-of-line)
	    (buffer-substring current-start (point)))))
    nil))

(defun mvc-status-get-current-line-file-name ()
  (let ((file-name (mvc-status-get-current-line-string)))
    (if file-name
	(setq file-name (substring file-name (+ mvc-l-status-mvcstatus-header-rawstatus 9)))
      nil)))

(defun mvc-status-get-current-line-file-name-with-prefix ()
  (let ((file-name (mvc-status-get-current-line-string)))
    (if file-name
	(setq file-name (substring file-name (+ mvc-l-status-mvcstatus-header-rawstatus 7)))
      nil)))

(defun mvc-status-redraw-footer-marks ()
  (save-excursion
    (goto-char mvc-l-status-file-list-end-point)
    (search-forward "marks:" nil t)
    (setq buffer-read-only nil)
    (delete-region (point) (+ (point) 5))
    (mvc-insert-with-face (format "%-5d" mvc-l-status-marks)
			  'mvc-face-status-footer)
    (setq buffer-read-only t)))

(defsubst mvc-backup-file-p (file-name)
  (string-match "[~#]$" file-name))

(defun mvc-status-draw-status-list ()
  (let ((expanded-dir (expand-file-name default-directory)))
    (maphash #'(lambda (key value)
		 (let ((flag t) (mark (gethash key mvc-l-status-mark-hash)))
		   (unless (string= mark "*")
		     (cond ((and (not mvc-l-status-display-unknown-p)
				 (string= value "?"))
			    (setq mvc-l-status-display-unknown-masks (1+ mvc-l-status-display-unknown-masks))
			    (setq flag nil))
			   ((and (not mvc-l-status-display-ignore-p)
				 (string= value "I"))
			    (setq mvc-l-status-display-ignore-masks (1+ mvc-l-status-display-ignore-masks))
			    (setq flag nil))
			   ((and (not mvc-l-status-display-delete-p)
				 (string= value "D"))
			    (setq mvc-l-status-display-delete-masks (1+ mvc-l-status-display-delete-masks))
			    (setq flag nil))
			   ((and (not mvc-l-status-display-unmodified-p)
				 (not (stringp (gethash (concat expanded-dir (substring key 2)) mvc-l-status-after-save-hook-hash)))
				 (not (and (string= (gethash key mvc-l-status-type-hash) "d")
					   (string= (substring key 2) ".")))
				 (string= value " "))
			    (setq mvc-l-status-display-unmodified-masks (1+ mvc-l-status-display-unmodified-masks))
			    (setq flag nil))))
		   (when (and (not mvc-l-status-display-backup-p)
			      (mvc-backup-file-p key)
			      (string= value "?")
			      (not (string= mark "*")))
		     (setq mvc-l-status-display-backup-masks (1+ mvc-l-status-display-backup-masks))
		     (setq flag nil))
		   (when (and (string= "d" (gethash key mvc-l-status-type-hash))
			      (not mvc-l-status-display-unmodified-p)
			      (not (string= mark "*"))
			      (not (string= "  ." key)))
		     (let ((information (gethash key mvc-l-status-information-hash)))
		       (when (= (cdr (assq 'tracked information)) 0)
			 (setq flag nil))
		       (when (and mvc-l-status-display-unknown-p
				  (>= (- (cdr (assq 'untracked information)) (cdr (assq '~ information))) 1))
			 (setq flag t))
		       (when (and mvc-l-status-display-backup-p
				  mvc-l-status-display-unknown-p
				  (>= (cdr (assq '~ information)) 1))
			 (setq flag t))
		       (when (and mvc-l-status-display-ignore-p
				  (>= (cdr (assq 'I information)) 1))
			 (setq flag t))
		       (when (and mvc-l-status-display-delete-p
				  (>= (cdr (assq 'D information)) 1))
			 (setq flag t))
		       (when (>= (cdr (assq '! information)) 1)
			 (setq flag t))))
		   (when flag
		     (puthash key (point) mvc-l-status-point-hash)
		     (insert (cond ((not mark) "  ")
				   ((string= mark "*") "* ")))

		     (insert " ")
		     (let ((tmp (gethash (concat expanded-dir (substring key 2)) mvc-l-status-after-save-hook-hash)))
		       (if (stringp tmp)
			   (mvc-insert-with-face tmp 'mvc-face-status-modified)
			 (mvc-insert-with-face " " 'mvc-face-status-modified)))

		     (cond ((string= "M" value)
			    (mvc-insert-with-face (concat " " value " " key "\n")
						  'mvc-face-status-modified))
			   ((stringp (gethash (concat expanded-dir (substring key 2)) mvc-l-status-after-save-hook-hash))
			    (mvc-insert-with-face (concat " " value " " key "\n")
						  'mvc-face-status-modified))
			   ((string= "d" (gethash key mvc-l-status-type-hash))
			    (mvc-insert-with-face (concat " " "d" " " key "\n")
						  'mvc-face-status-directory))
			   (t
			    (insert (concat " " value " " key "\n"))))
		     (unless (eobp)
		       (delete-region (point) (1+ (line-end-position)))))))
	     mvc-l-status-code-hash)))

(defun mvc-status-draw-footer ()
  (delete-region (point) (point-max))
  (mvc-insert-with-face (concat "information: " mvc-l-status-mvcstatus-header-information "\n")
			'mvc-face-status-footer)
  (mvc-status-insert-toggle-button mvc-l-status-strict-p
				   "status strict"
				   "status  fast "
				   'mvc-status-mode-toggle-strict-or-fast)
  (mvc-insert-with-face " "
			'mvc-face-status-footer)
  (mvc-status-insert-toggle-button (not mvc-l-status-command-no-argument-p)
				   "command(log/commit) argument ON"
				   "command(log/commit) NO ARGUMENT"
				   'mvc-status-mode-toggle-command-no-argument)
  (mvc-insert-with-face (format "    files:%-5d  marks:%-5d " mvc-l-status-files mvc-l-status-marks)
			'mvc-face-status-footer)
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)

  (mvc-insert-with-face "mask file(s):"
			'mvc-face-status-footer)
  (mvc-insert-with-face (if mvc-l-status-display-unknown-p
			    "?=show all   "
			  (format "?=HIDE %-5d " mvc-l-status-display-unknown-masks))
			'mvc-face-status-footer)
  (mvc-insert-with-face (if mvc-l-status-display-unmodified-p
			    "C=show all   "
			  (format "C=HIDE %-5d " mvc-l-status-display-unmodified-masks))
			'mvc-face-status-footer)
  (mvc-insert-with-face (if mvc-l-status-display-backup-p
			    "~#=show all   "
			  (format "~#=HIDE %-5d " mvc-l-status-display-backup-masks))
			'mvc-face-status-footer)
  (mvc-insert-with-face (if mvc-l-status-display-ignore-p
			    "I=show all   "
			  (format "I=HIDE %-5d " mvc-l-status-display-ignore-masks))
			'mvc-face-status-footer)
  (mvc-insert-with-face (if mvc-l-status-display-delete-p
			    "D=show all   "
			  (format "D=HIDE %-5d " mvc-l-status-display-delete-masks))
			'mvc-face-status-footer)
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)

  (when mvc-default-use-button
    (mvc-status-insert-button "<=(M-S-TAB)" 'mvc-status-mode-previous-status)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "=>(M-TAB)" 'mvc-status-mode-next-status)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "push(>)" 'mvc-status-mode-push)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "pull(<)" 'mvc-status-mode-pull)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "status(s or g)" 'mvc-status-mode-status)
    (unless (eq mvc-l-status-program 'git)
      (mvc-insert-with-face " "
			    'mvc-face-status-footer)
      (mvc-status-insert-button "update(U)" 'mvc-status-mode-update))
    (mvc-insert-with-face " \n"
			  'mvc-face-status-footer)

    (mvc-status-insert-button "unmark all(*!)" 'mvc-status-mode-unmark-all)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "mark modified(*M)" 'mvc-status-mode-mark-modified)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "mark add(*A)" 'mvc-status-mode-mark-add)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "mark unknown(*?)" 'mvc-status-mode-mark-unknown)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "mark remove(*D)" 'mvc-status-mode-mark-remove)
    (mvc-insert-with-face " \n"
			  'mvc-face-status-footer)

    (mvc-status-insert-button "  mark path regexp(*R)" 'mvc-status-mode-mark-path-regexp)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-button "unmark path regexp(*R)" 'mvc-status-mode-unmark-path-regexp)
    (mvc-insert-with-face " \n"
			  'mvc-face-status-footer)

    (mvc-status-insert-toggle-button (not mvc-l-status-display-unknown-p)
				     "unknown mask enabled (\\C-c?)"
				     "unknown mask disabled(\\C-c?)"
				     'mvc-status-mode-toggle-display-unknown)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-toggle-button (not mvc-l-status-display-unmodified-p)
				     "unmodified mask enabled (\\C-c_)"
				     "unmodified mask disabled(\\C-c_)"
				     'mvc-status-mode-toggle-display-unmodified)
    (mvc-insert-with-face " \n"
			  'mvc-face-status-footer)

    (mvc-status-insert-toggle-button (not mvc-l-status-display-backup-p)
				     " backup mask enabled (\\C-c~)"
				     " backup mask disabled(\\C-c~)"
				     'mvc-status-mode-toggle-display-backup)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-toggle-button (not mvc-l-status-display-ignore-p)
				     "    ignore mask enabled (\\C-ci)"
				     "    ignore mask disabled(\\C-ci)"
				     'mvc-status-mode-toggle-display-ignore)
    (mvc-insert-with-face " "
			  'mvc-face-status-footer)
    (mvc-status-insert-toggle-button (not mvc-l-status-display-delete-p)
				     "    delete mask enabled "
				     "    delete mask disabled"
				     'mvc-status-mode-toggle-display-delete)
    (mvc-insert-with-face " \n"
			  'mvc-face-status-footer)

    (when (eq mvc-l-status-program 'subversion)
      (mvc-status-insert-toggle-button mvc-l-status-recursive-p
				       "recursive enabled "
				       "recursive disabled"
				       'mvc-status-mode-toggle-recursive)
      (mvc-insert-with-face " \n"
			    'mvc-face-status-footer)))

  (mvc-insert-with-face "last update:"
			'mvc-face-status-footer)
  (if mvc-l-status-last-execute-time-update
      (mvc-insert-with-face (current-time-string mvc-l-status-last-execute-time-update)
			    'mvc-face-status-footer)
    (mvc-insert-with-face mvc-header-string-time
			  'mvc-face-status-footer))
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)
  (mvc-insert-with-face "last status:"
			'mvc-face-status-footer)
  (if mvc-l-status-last-execute-time-status
      (mvc-insert-with-face (current-time-string mvc-l-status-last-execute-time-status)
			    'mvc-face-status-footer)
    (mvc-insert-with-face mvc-header-string-time
			  'mvc-face-status-footer))
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)
  (mvc-insert-with-face "last commit:"
			'mvc-face-status-footer)
  (if mvc-l-status-last-execute-time-commit
      (mvc-insert-with-face (current-time-string mvc-l-status-last-execute-time-commit)
			    'mvc-face-status-footer)
    (mvc-insert-with-face mvc-header-string-time
			  'mvc-face-status-footer))
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)
  (mvc-insert-with-face "last   push:"
			'mvc-face-status-footer)
  (if mvc-l-status-last-execute-time-push
      (mvc-insert-with-face (current-time-string mvc-l-status-last-execute-time-push)
			    'mvc-face-status-footer)
    (mvc-insert-with-face mvc-header-string-time
			  'mvc-face-status-footer))
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)
  (mvc-insert-with-face "last   pull:"
			'mvc-face-status-footer)
  (if mvc-l-status-last-execute-time-pull
      (mvc-insert-with-face (current-time-string mvc-l-status-last-execute-time-pull)
			    'mvc-face-status-footer)
    (mvc-insert-with-face mvc-header-string-time
			  'mvc-face-status-footer))
  (mvc-insert-with-face "\n"
			'mvc-face-status-footer)
  (mvc-insert-with-face "branch\n"
			'mvc-face-status-footer)
  (if (and (boundp 'mvc-l-status-branch-name)
	   mvc-l-status-branch-name)
      (insert mvc-l-status-branch-name)
    (insert "?"))
  (insert "\n"))

;; hash の内容からステータスバッファを描画します。
(defun mvc-status-draw ()
  (setq mvc-l-status-ready-p nil)

  (setq mvc-l-status-display-unknown-masks 0)
  (setq mvc-l-status-display-unmodified-masks 0)
  (setq mvc-l-status-display-backup-masks 0)
  (setq mvc-l-status-display-ignore-masks 0)
  (setq mvc-l-status-display-delete-masks 0)

  (setq buffer-read-only nil)
  (goto-char (point-min))
  (clrhash mvc-l-status-point-hash)

  (setq mvc-l-status-file-list-begin-point (point-min))
  (mvc-status-draw-status-list)
  (setq mvc-l-status-file-list-end-point (1- (point)))

  (mvc-status-draw-footer)
  (setq buffer-read-only t)
  (set-buffer-modified-p nil)
  (setq mvc-l-status-ready-p t))

(defun mvc-status-draw-with-save-load-point ()
  (mvc-status-save-point)
  (mvc-status-draw)
  (mvc-status-load-point))

(defun mvc-status-save-point ()
  (setq mvc-l-status-save-load-point (point))
  (if (>= (point) mvc-l-status-file-list-end-point)
      (setq mvc-l-status-save-load-file-list-end-point mvc-l-status-file-list-end-point)
    (setq mvc-l-status-save-load-file-list-end-point nil)
    (setq mvc-l-status-save-load-file-name (mvc-status-get-current-line-file-name-with-prefix))
    (setq mvc-l-status-save-load-window-point-hash (make-hash-table))
    (setq mvc-l-status-save-load-window-file-name-hash (make-hash-table))
    (let ((status-buffer (current-buffer)))
      (mapc #'(lambda (a)
		(puthash a (window-point a) mvc-l-status-save-load-window-point-hash)
		(save-excursion
		  (goto-char (window-point a))
		  (puthash a
			   (mvc-status-get-current-line-file-name)
			   mvc-l-status-save-load-window-file-name-hash)))
	    (get-buffer-window-list (buffer-name status-buffer) 'ignore t)))))

(defun mvc-status-load-point ()
  (if mvc-l-status-save-load-file-list-end-point
      (if mvc-l-status-first-point-set-p
	  (goto-char (+ mvc-l-status-file-list-end-point
			(- mvc-l-status-save-load-point
			   mvc-l-status-save-load-file-list-end-point)))
	(setq mvc-l-status-first-point-set-p t)
	(goto-char mvc-l-status-file-list-begin-point))
    (let ((point (gethash mvc-l-status-save-load-file-name mvc-l-status-point-hash)))
      (if point
	  (goto-char point)
	(if (> mvc-l-status-save-load-point mvc-l-status-file-list-end-point)
	    (goto-char mvc-l-status-file-list-end-point)
	  (goto-char mvc-l-status-save-load-point))
	(beginning-of-line)))
    (maphash #'(lambda (key value)
		 (when (and (window-live-p key)
			    (not (eq (selected-window) key)))
		   (let ((point (gethash value mvc-l-status-point-hash)))
		     (if point
			 (set-window-point key point)
		       (set-window-point key (gethash key mvc-l-status-save-load-window-point-hash))))))
	     mvc-l-status-save-load-window-file-name-hash))
  (setq mvc-l-status-save-load-window-point-hash nil)
  (setq mvc-l-status-save-load-window-file-name-hash nil))




;;; mvc-cheat-sheet

(defun mvc-cheat-sheet ()
  (let* ((mvctmphist (cdr (assq mvc-l-status-program mvc-default-cheat-sheet-history)))
	 (status-buffer (current-buffer))
	 (base (concat "*mvc-"
		       (cdr (assq mvc-l-status-program mvc-program-display-name)))))
    (save-current-buffer
      (switch-to-buffer (get-buffer-create (mvc-create-buffer-name (concat base "-cheat-sheet*") default-directory)))
      (mvc-cheat-sheet-mode status-buffer)
      (when (= (point-max) 1)
	(let ((cheat-sheet-filename (concat mvc-default-cheat-sheet-directory ".mvc." (buffer-name))))
	  (setq buffer-file-name cheat-sheet-filename)
	  (if (file-exists-p cheat-sheet-filename)
	      (progn
		(insert-file-contents cheat-sheet-filename)
		(set-buffer-modified-p nil))
	    (insert "# \"\\C-c\\C-c\" to run current line command\n")
	    (mapcar #'(lambda (a)
			(insert (concat a "\n")))
		    mvctmphist)
	    (goto-char (point-min))))))))




;;; mvc-command

(defun mvc-command-get-current-or-mark-file-name-list (current-only-p)
  (let (file-name-list)
    (setq mvc-l-status-file-name-list-git-stage-count 0)
    (setq mvc-l-status-file-name-list-git-rename-count 0)
    (setq mvc-l-status-file-name-list-working-directory-count 0)
    (if (or (= mvc-l-status-marks 0)
	    current-only-p)
	(progn
	  (setq file-name-list (mvc-status-get-current-line-file-name))
	  (let ((file-name-with-prefix (mvc-status-get-current-line-file-name-with-prefix)))
	    (if (string= (substring file-name-with-prefix 0 2) "s:")
		(progn
		  (when (string= (gethash file-name-with-prefix mvc-l-status-code-hash) "R")
		    (setq mvc-l-status-file-name-list-git-rename-count 1))
		  (setq mvc-l-status-file-name-list-git-stage-count 1))
	      (setq mvc-l-status-file-name-list-working-directory-count 1)))
	  (when file-name-list
	    (setq file-name-list (list file-name-list))))
      (maphash #'(lambda (key value)
		   (when (string= (gethash key mvc-l-status-code-hash) "R")
		     (setq mvc-l-status-file-name-list-git-rename-count (1+ mvc-l-status-file-name-list-git-rename-count)))
		   (when (string= value "*")
		     (if (string= (substring key 0 2) "s:")
			 (setq mvc-l-status-file-name-list-git-stage-count (1+ mvc-l-status-file-name-list-git-stage-count))
		       (setq mvc-l-status-file-name-list-working-directory-count (1+ mvc-l-status-file-name-list-working-directory-count)))
		     (setq file-name-list (append file-name-list (list (substring key 2))))))
	       mvc-l-status-mark-hash))
    file-name-list))

;; カレント位置のファイルまたはマークされたファイルに対しコマンドを実行
;; します。

;; option-list が Non-nil ならば
;; mvc-status-get-current-program-option-list で生成されるデフォルトの
;; オプションの後ろに追加されます。 option-list が nil ならばデフォルト
;; のオプションがそのまま適用されます。 option-argument は
;; mvc-status-get-current-program-option-list の argument としてわたさ
;; れます。tail-file-list は引数の最後に追加されます。 current-only-p
;; が Non-nil ならばカレント位置のファイルに対してのみコマンドを実行し
;; ます。

;; mvc-command 系関数では必要な内部変数などは更新されますが window の操
;; 作はせず、バッファやポイントの状態が保存されないことに注意が必要です。
;; 実行が成功した場合は Non-nil を返し、対象のファイルが指定されていな
;; い場合や yes-or-no-p で no が返された場合や、すでに実行されていて失
;; 敗した場合などに nil を返します。
(defun mvc-command-current-or-mark (async-callback
				    display-p
				    command-key
				    &optional
				    yes-or-no-p option-list option-argument tail-file-list current-only-p ignore-check-process-p)
  (if (and (not ignore-check-process-p) mvc-l-status-process-process)
      (progn
	(message mvc-message-process-already-running)
	nil)
    (let* ((file-name-list (mvc-command-get-current-or-mark-file-name-list current-only-p))
	   (command-list (mvc-status-get-current-program-option-list command-key option-argument))
	   (command-name (nth 0 command-list))
	   (process-buffer-name (cdr (assq command-key mvc-l-status-buffer-name-list))))
      (if file-name-list
	  (progn
	    (let ((flag t)
		  (program-name mvc-l-status-program-name))
	      (when (or (and (eq command-key 'commit)
			     mvc-l-status-command-no-argument-p)
			(and (eq command-key 'log)
			     mvc-l-status-command-no-argument-p))
		(setq file-name-list nil))
	      (when yes-or-no-p
		(setq flag (yes-or-no-p (if (<= mvc-l-status-marks 1)
					    (concat command-name " " (nth 0 file-name-list) "?")
					  (format "%s %d files?" command-name mvc-l-status-marks)))))
	      (if flag
		  (let ((mvc-program-name mvc-l-status-mvc-program-name)
			(program mvc-l-status-program)
			(status-buffer (current-buffer))
			(status-default-directory default-directory))
		    (message "%s %s ..." program-name command-name)
		    (setq mvc-l-status-process-last-command command-name)
		    (if (and (string= process-buffer-name (cdr (assq 'process-temporary mvc-l-status-buffer-name-list)))
			     (not async-callback))
			(mvc-process nil display-p t
				     status-buffer (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))
				     (append (list mvc-program-name)
					     (cdr (assq program (cdr (assq command-key (mvc-get-mvc-default-option-list)))))
					     (list "--" program-name)
					     command-list option-list file-name-list tail-file-list))
		      (mvc-process async-callback display-p nil
				   status-buffer process-buffer-name
				   (append (list mvc-program-name)
					   (cdr (assq program (cdr (assq command-key (mvc-get-mvc-default-option-list)))))
					   (list "--" program-name)
					   command-list option-list file-name-list tail-file-list)
				   program-name command-name async-callback))
		    t)
		(message  "%s %s canceled!" program-name command-name)
		nil)))
	(message "unknown line!")
	nil))))

(defun mvc-process-sentinel (process event)
  (with-current-buffer (process-buffer process)
    (with-current-buffer mvc-l-process-status-buffer
      (setq mvc-l-status-process-process nil)
      (mvc-status-update-header-line))
    (cond ((or (string-match "^finished" event)
	       (string-match "^exited abnormally with code" event))
	   (goto-char (point-min))
	   (when (get-buffer-window (current-buffer))
	     (set-window-point (get-buffer-window (current-buffer)) (point)))
	   (message mvc-l-process-done-message)
	   ;; ここで mode 設定などをしたときに local variable がクリアされる場合があることに注意
	   (let ((kill-buffer-p mvc-l-process-kill-buffer-p))
	     (save-current-buffer
	       (funcall mvc-l-process-callback mvc-l-process-status-buffer))
	     (when kill-buffer-p
	       (kill-buffer (process-buffer process)))))
	  (t
	   (message (concat "process error error:" event))))))

(defun mvc-process-filter (proc string)       
  (with-current-buffer (process-buffer proc)         
    (save-excursion                                
      (goto-char (process-mark proc))              
      (setq buffer-read-only nil)
      (insert string)                              
      (setq buffer-read-only t)
      (set-marker (process-mark proc) (point)))    
      (goto-char (process-mark proc))))

(defun mvc-process (async-p
		    display-p
		    kill-buffer-p
		    status-buffer
		    process-buffer-name
		    command-list
		    &optional
		    program-name
		    command-name
		    process-sentinel-callback)
  (with-current-buffer (get-buffer-create process-buffer-name)
    (setq buffer-read-only nil)
    (erase-buffer)
    (kill-all-local-variables)
    (setq buffer-undo-list t)
    (when display-p
      (display-buffer (current-buffer))
      (when (not async-p)
	(recenter '(dummy))))
    (when (not program-name)
      (setq program-name ""))
    (when (not command-name)
      (setq command-name ""))
    (if async-p
	(let ((process-connection-type mvc-default-process-connection-type))
	  (setq buffer-read-only t)
	  (set (make-local-variable 'mvc-l-process-status-buffer) status-buffer)
	  (set (make-local-variable 'mvc-l-process-callback) process-sentinel-callback)
	  (set (make-local-variable 'mvc-l-process-done-message) (format "%s %s ...done" program-name command-name))
	  (set (make-local-variable 'mvc-l-process-kill-buffer-p) kill-buffer-p)
	  (with-current-buffer status-buffer
	    (setq mvc-l-status-process-buffer-name process-buffer-name)
	    (setq mvc-l-status-process-process (apply 'start-process
						      process-buffer-name
						      process-buffer-name
						      (nth 0 command-list)
						      (cdr command-list)))
	    (when display-p
	      (set-process-filter mvc-l-status-process-process 'mvc-process-filter))
	    (set-process-sentinel mvc-l-status-process-process 'mvc-process-sentinel))
	  (message "%s %s async processing..." program-name command-name))
      (apply 'call-process (nth 0 command-list) nil display-p display-p (cdr command-list))
      (when kill-buffer-p
	(kill-buffer process-buffer-name)))))

(defun mvc-command-diff-ediff-p ()
  (let ((file-name-list (mvc-command-get-current-or-mark-file-name-list t)))
    (when file-name-list
      (not (file-directory-p (nth 0 file-name-list))))))

(defun mvc-command-diff-ediff ()
  (let* ((file-name (mvc-status-get-current-line-file-name))
	 (status-buffer (current-buffer))
	 (buffer-a-name)
	 ;; (buffer-b-name)
	 (program-name mvc-l-status-program-name))
    (setq buffer-a-name (cdr (assq 'result mvc-l-status-buffer-name-list)))
    (when (get-buffer buffer-a-name)
      (kill-buffer buffer-a-name))
    (let ((default-process-coding-system mvc-default-process-coding-system))
      ;; ここだけ他とは異なり、 temporary を result の名前に変更している。
      (mvc-call-process-and-set-buffer-temporary status-buffer
						 mvc-l-status-mvc-program-name
						 (append (cdr (assq mvc-l-status-program (cdr (assq 'diff (mvc-get-mvc-default-option-list)))))
							 (list "--" mvc-l-status-program-name "cat" file-name)))
      (rename-buffer buffer-a-name))
    (ediff-buffers buffer-a-name (find-file file-name))))

(defun mvc-command-diff-only-current (prefix-argument)
  (mvc-command-current-or-mark (lambda (status-buffer)
				 (diff-mode))
			       t
			       'diff
			       nil
			       nil
			       prefix-argument
			       nil
			       t
			       t))

(defun mvc-command-diff-current-or-mark (prefix-argument)
  (mvc-command-current-or-mark (lambda (status-buffer)
				 (diff-mode))
			       t
			       'diff
			       nil
			       nil
			       prefix-argument
			       nil
			       nil
			       t))

(defun mvc-command-add ()
  (mvc-command-current-or-mark (lambda (status-buffer)
				 (with-current-buffer status-buffer
				   (kill-buffer (cdr (assq 'process-temporary mvc-l-status-buffer-name-list)))
				   (mvc-async-status)))
			       nil
			       'add))

(defun mvc-command-annotate ()
  (mvc-command-current-or-mark (lambda (status-buffer)
				 (with-current-buffer status-buffer
				   (mvc-show-call-process-temporary-result status-buffer t)
				   (goto-char (point-min))))
			       nil
			       'annotate))

(defun mvc-command-commit ()
  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (let ((marks mvc-l-status-marks)
	  (code-hash mvc-l-status-code-hash)
	  (file-name (mvc-status-get-current-line-file-name))
	  (status-buffer (current-buffer))
	  commitlog-buffer-name
	  result-buffer-name
	  file-name-list
	  (run-server-p (and mvc-default-use-emacs-client
			     (fboundp 'server-running-p)
			     (server-running-p))))
      (setq commitlog-buffer-name (cdr (assq 'commitlog mvc-l-status-buffer-name-list)))
      (setq result-buffer-name (cdr (assq 'result mvc-l-status-buffer-name-list)))
      (if (or file-name
	      mvc-l-status-command-no-argument-p
	      (>= marks 1))
	  (progn
	    (unless mvc-l-status-command-no-argument-p
	      (if (= marks 0)
		  (setq file-name-list (list file-name))
		(maphash #'(lambda (key value)
			     (when (string= value "*")
			       (setq file-name-list (append file-name-list (list key)))))
			 mvc-l-status-mark-hash)))

	    (setq mvc-l-status-last-window-configuration (current-window-configuration))
	    (let ((mvc-program-name mvc-l-status-mvc-program-name)
		  (command-no-argument-p mvc-l-status-command-no-argument-p)
		  (program mvc-l-status-program)
		  (program-name mvc-l-status-program-name)
		  (commit-message mvc-default-commit-message)
		  (log-option (mvc-status-get-current-program-option-list 'log))
		  (status-option (mvc-status-get-current-program-option-list 'status)))
	      (switch-to-buffer (get-buffer-create result-buffer-name))
	      (setq buffer-undo-list t)
	      (setq buffer-read-only nil)

	      (erase-buffer)
	      (if command-no-argument-p
		  (progn
		    (mvc-insert-with-face "** NO ARGUMENT MODE!\n"
					  'mvc-face-commit-headline)
		    (let ((insert-point (point)))
		      (apply 'call-process program-name nil t nil (append
								   status-option))
		      (goto-char (point-min))
		      (if (re-search-forward "^Changes to be committed:$" nil t)
			  (progn
			    (let (face-point-start face-point-end)
			      (beginning-of-line)
			      (setq face-point-start (point))
			      (end-of-line)
			      (setq face-point-end (point))
			      (set-text-properties face-point-start
						   (+ face-point-start (- face-point-end face-point-start))
						   (list 'face 'mvc-face-commit-git-commit-underline)))
			    (let (face-point-start face-point-end)
			      (forward-line 1)
			      (beginning-of-line)
			      (setq face-point-start (point))
			      (search-forward "\n\n" nil t)
			      (search-forward "\n\n" nil t)
			      (forward-line -1)
			      (setq face-point-end (point))
			      (set-text-properties face-point-start
						   (+ face-point-start (- face-point-end face-point-start))
						   (list 'face 'mvc-face-commit-git-commit))))
			(goto-char insert-point)
			(insert "\n")
			(mvc-insert-with-face "#### NO COMMIT FILES ####" 'mvc-face-commit-warning)
			(insert "\n\n"))
		      (goto-char (point-max))))
		(if (<= marks 1)
		    (mvc-insert-with-face "** File to commit\n"
					  'mvc-face-commit-headline)
		  (mvc-insert-with-face (format "** Commit %d files\n" marks)
					'mvc-face-commit-headline)))

	      (mapc #'(lambda (a)
			(when (string= a ".")
			  (mvc-insert-with-face "#### ROOT DIRECTORY ####\n"
						'mvc-face-commit-warning))
			(when (string= (gethash a code-hash) "?")
			  (mvc-insert-with-face "#### UNKNOWN FILE ####\n"
						'mvc-face-commit-warning))
			(insert (concat "    " a))
			(insert "\n"))
		    file-name-list)
	      (insert "\n")

	      (mvc-insert-with-face (format "** Log  ($ %s log \".\")\n" program-name)
				    'mvc-face-commit-headline)

	      ;; ここに insert したいので call-process を直接使用。
	      (apply 'call-process mvc-program-name nil t nil (append
							       (cdr (assq program (cdr (assq 'log (mvc-get-mvc-default-option-list status-buffer)))))
							       (list "--" program-name)
							       log-option
							       (list ".")))

	      (let ((buffer (get-buffer commitlog-buffer-name)))
		(goto-char (point-min))
		(mvc-insert-with-face "** Information\n"
				      'mvc-face-commit-headline)
		(when (and (not run-server-p)
			   (not buffer)
			   commit-message)
		  (mvc-insert-with-face "    * insert default commit message\n"
					'mvc-face-commit-warning))
		(mvc-insert-with-face (concat "    * directory:" default-directory "\n")
				      'mvc-face-commit-information)
		(insert "\n")
		(mvc-log-mode status-buffer)
		(setq buffer-read-only t)
		(goto-char (point-min))

		(when (not run-server-p)
		  (if buffer
		      (switch-to-buffer-other-window buffer)
		    (switch-to-buffer-other-window (get-buffer-create commitlog-buffer-name))
		    (when commit-message
		      (insert commit-message))))))
	    (if run-server-p
		(progn
		  (switch-to-buffer (get-buffer-create result-buffer-name))
		  (set-buffer status-buffer)
		  (mvc-command-current-or-mark (lambda (status-buffer)
						 (with-current-buffer status-buffer
						   (mvc-async-status)
						   (switch-to-buffer status-buffer))) nil 'commit)
		  (switch-to-buffer-other-window result-buffer-name))
	      (mvc-commitlog-mode status-buffer)))
	(message "no commit file!")))))

(defun mvc-command-log (prefix-argument)
  (mvc-command-current-or-mark (lambda (status-buffer) (mvc-log-mode status-buffer))
			       nil
			       'log
			       nil
			       nil
			       prefix-argument
			       nil
			       nil
			       t))

(defun mvc-command-revert ()
  (mvc-command-current-or-mark (lambda (status-buffer)
				 (with-current-buffer status-buffer
				   (let ((especial-buffer-name (cdr (assq 'especial mvc-l-status-buffer-name-list))))
				     (when (get-buffer especial-buffer-name)
				       (kill-buffer especial-buffer-name)
				       (message "buffer \"%s\" killed by revert" especial-buffer-name))
				     (kill-buffer (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))))
				   (mvc-async-status)))
			       nil
			       'revert
			       t))

(defun mvc-command-remove ()
  (when (mvc-command-current-or-mark nil nil 'remove)
    (mvc-async-status)))

(defun mvc-command-rename (destination)
  (when (mvc-command-current-or-mark nil nil
				     'rename
				     nil
				     nil
				     nil
				     (list destination))
    (mvc-async-status)))




;;; mvc-async

(defun mvc-async-status-process-sentinel-add (status-buffer key code type information old-hash)
  (with-current-buffer status-buffer
    (puthash key code mvc-l-status-code-hash)
    (puthash key type mvc-l-status-type-hash)
    (when information
      (string-match "tracked:\\([0-9]+\\) M:\\([0-9]+\\) A:\\([0-9]+\\) D:\\([0-9]+\\) \\?:\\([0-9]+\\) I:\\([0-9]+\\) C:\\([0-9]+\\) !:\\([0-9]+\\) ~:\\([0-9]+\\)" information)
      (puthash key `((tracked . ,(string-to-number (match-string 1 information)))
		     (M . ,(string-to-number (match-string 2 information)))
		     (A . ,(string-to-number (match-string 3 information)))
		     (D . ,(string-to-number (match-string 4 information)))
		     (untracked . ,(string-to-number (match-string 5 information)))
		     (I . ,(string-to-number (match-string 6 information)))
		     (C . ,(string-to-number (match-string 7 information)))
		     (! . ,(string-to-number (match-string 8 information)))
		     (~ . ,(string-to-number (match-string 9 information))))
	       mvc-l-status-information-hash))
    (puthash key 0 mvc-l-status-point-hash)
    (puthash (concat (expand-file-name default-directory) (substring key 2)) t mvc-l-status-after-save-hook-hash)
    (let ((oldvalue (gethash key old-hash)))
      (if oldvalue
	  (progn
	    (when (string= oldvalue "*")
	      (setq mvc-l-status-marks (1+ mvc-l-status-marks)))
	    (puthash key "*" mvc-l-status-mark-hash))
	(puthash key nil mvc-l-status-mark-hash)))))

(defun mvc-async-status-lambda ()
  (lambda (status-buffer)
    (goto-char (point-min))
    (re-search-forward "version:\\(.+\\)")
    (let ((version (match-string 1)))
      (unless (string= version mvc-version-string)
	(message "illegal version \"%s\"" version)))
    (re-search-forward "rawstatus:\\([0-9]+\\)")
    (let ((header-rawstatus (string-to-number (match-string 1))))
      ;; FIXME! 本来ここで mvc-l-status-mvcstatus-header-rawstatus を設定すべきだが、 0 前提のコードが含まれているので修正は保留。
      ;; (with-current-buffer status-buffer
      ;; 	(setq mvc-l-status-mvcstatus-header-rawstatus header-rawstatus))
      (re-search-forward "^HEADEREND$" nil t)
      (with-current-buffer status-buffer
	(setq mvc-l-status-mvcstatus-header-information ""))
      (let ((header-end-point (point))
	    tmp)
	(save-excursion
	  (goto-char (point-min))
	  (when (re-search-forward "^information:\\(.+\\)" header-end-point t)
	    (setq tmp (match-string 1))
	    (with-current-buffer status-buffer
	      (setq mvc-l-status-mvcstatus-header-information tmp)))))
      (forward-line)
      (let (old-hash)
	(with-current-buffer status-buffer
	  (setq mvc-l-status-last-execute-time-status (current-time))
	  (setq old-hash (copy-hash-table mvc-l-status-mark-hash))
	  (setq mvc-l-status-files 0)
	  (setq mvc-l-status-marks 0)
	  (clrhash mvc-l-status-mark-hash)
	  (clrhash mvc-l-status-code-hash)
	  (clrhash mvc-l-status-type-hash)
	  (clrhash mvc-l-status-information-hash)
	  (clrhash mvc-l-status-after-save-hook-hash))
	(let ((files 0))
	  (while (< (point) (point-max))
	    (if (char-equal (char-after) ?/)
		(progn
		  (forward-line))
	      (let* ((start (point))
		     (rawstatus (buffer-substring start (+ start header-rawstatus)))
		     (mvcstatus (buffer-substring (+ start header-rawstatus 1) (+ start header-rawstatus 2)))
		     (type (buffer-substring (+ start header-rawstatus 3) (+ start header-rawstatus 4)))
		     information
		     file-name-with-prefix-and-info
		     file-name-with-prefix)
		(end-of-line)
		(setq file-name-with-prefix-and-info (buffer-substring (+ start header-rawstatus 5) (point)))
		(if (string-match "\\(        // .+\\)$" file-name-with-prefix-and-info)
		    (progn
		      (setq information (match-string 1 file-name-with-prefix-and-info))
		      (setq file-name-with-prefix (substring file-name-with-prefix-and-info 0 (* -1 (length information)))))
		  (setq file-name-with-prefix file-name-with-prefix-and-info))
		(mvc-async-status-process-sentinel-add status-buffer file-name-with-prefix mvcstatus type information old-hash)
		(setq files (1+ files))
		(forward-line))))
	  (with-current-buffer status-buffer
	    (setq mvc-l-status-files files)
	    (setq mvc-l-status-branch-name (mvc-status-mode-get-branch-name))
	    (setq mvc-l-status-timer-last-mode-line-string "")
	    (mvc-status-update-header-line)))))
    (with-current-buffer status-buffer
      (mvc-status-draw-with-save-load-point)
      (message "%s status ...done" mvc-l-status-program-name))))

;; 非同期で "mvc status" を実行します。
;;
;; initial-program に Non-nil を指定するのは
;;
;; 「status バッファが存在しない初回起動時のみ」
;;
;; であることに注意が必要です。
(defun mvc-async-status (&optional initial-program)
  (if (mvc-status-mode initial-program)
      (progn
	(if mvc-l-status-process-process
	    (message mvc-message-process-already-running)
	  (let ((option-list (mvc-status-get-current-program-option-list 'status)))
	    (setq mvc-l-status-process-last-command (nth 0 option-list))
	    (let ((status-buffer (current-buffer))
		  (async-process-name (cdr (assq 'process-async mvc-l-status-buffer-name-list)))
		  (async-process-buffer-name (cdr (assq 'process-async mvc-l-status-buffer-name-list))))
	      (mvc-process t nil t
			   (current-buffer)
			   async-process-buffer-name
			   (append (list mvc-l-status-mvc-program-name)
				   (cdr (assq mvc-l-status-program (cdr (assq 'status (mvc-get-mvc-default-option-list)))))
				   (list "--" mvc-l-status-program-name)
				   option-list)
			   mvc-l-status-program-name "status"
			   (mvc-async-status-lambda)))))
	t)
    (message "mvc.el : SETUP FAILED!")
    nil))

(defun mvc-async-update-lambda ()
  (lambda (status-buffer)
    (let (result-buffer-name async-process-buffer-name)
      (with-current-buffer status-buffer
	(setq mvc-l-status-last-execute-time-update (current-time))
	(setq result-buffer-name (cdr (assq 'result mvc-l-status-buffer-name-list)))
	(setq async-process-buffer-name (cdr (assq 'process-async mvc-l-status-buffer-name-list))))
      (save-current-buffer
	(save-selected-window
	  (switch-to-buffer-other-window (get-buffer-create result-buffer-name))
	  (setq buffer-undo-list t)
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (insert-buffer-substring async-process-buffer-name)
	  (setq buffer-read-only t))))
    (with-current-buffer status-buffer
      (mvc-async-status))))

(defun mvc-async-update ()
  (let ((status-buffer (current-buffer)))
    (if mvc-l-status-process-process
	(message mvc-message-process-already-running)
      (setq mvc-l-status-process-last-command "update")
      (let ((async-process-name (cdr (assq 'process-async mvc-l-status-buffer-name-list)))
	    (async-process-buffer-name (cdr (assq 'process-async mvc-l-status-buffer-name-list))))
	(mvc-process t nil nil
		     (current-buffer)
		     async-process-buffer-name
		     (append (list mvc-l-status-mvc-program-name)
			     (cdr (assq mvc-l-status-program (cdr (assq 'update (mvc-get-mvc-default-option-list)))))
			     (list "--" mvc-l-status-program-name "update"))
		     mvc-l-status-program-name "update"
		     (mvc-async-update-lambda))))))

(defun mvc-async-push-pull-core-lambda ()
  (lambda (status-buffer)
    (let (result-buffer-name async-process-buffer-name)
      (with-current-buffer status-buffer
	(setq result-buffer-name (cdr (assq 'result mvc-l-status-buffer-name-list)))
	(setq async-process-buffer-name (cdr (assq 'process-async mvc-l-status-buffer-name-list)))
	(if (string= mvc-l-status-process-last-command "push")
	    (setq mvc-l-status-last-execute-time-push (current-time))
	  (setq mvc-l-status-last-execute-time-pull (current-time))))
      (save-current-buffer
	(save-selected-window
	  (switch-to-buffer-other-window (get-buffer-create result-buffer-name))
	  (setq buffer-undo-list t)
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (insert-buffer-substring async-process-buffer-name)
	  (setq buffer-read-only t)))
      (with-current-buffer status-buffer
	(kill-buffer async-process-buffer-name)
	(mvc-status-mode-status)))))

(defun mvc-async-push-pull-core (status-buffer command command-list path to-from)
  (if (yes-or-no-p (concat (nth 0 command-list) " " to-from " \"" path "\"?  "))
      (progn
	;; (set-buffer status-buffer)
	(setq mvc-l-status-process-last-command (nth 0 command-list))
	(let ((async-process-name (cdr (assq 'process-async mvc-l-status-buffer-name-list)))
	      (async-process-buffer-name (cdr (assq 'process-async mvc-l-status-buffer-name-list))))
	  (mvc-process t nil nil
		       (current-buffer)
		       async-process-buffer-name
		       (append (list mvc-l-status-mvc-program-name)
			       (cdr (assq mvc-l-status-program (cdr (assq command (mvc-get-mvc-default-option-list)))))
			       (list "--" mvc-l-status-program-name (nth 0 command-list)))
		       mvc-l-status-program-name (nth 0 command-list)
		       (mvc-async-push-pull-core-lambda))))
    (message  "%s %s canceled!" mvc-l-status-program-name (nth 0 command-list))))

(defun mvc-async-push-mercurial ()
  (let ((command-list (list "push"))
	(path "?")
	(program-name mvc-l-status-program-name)
	(status-buffer (current-buffer)))
    (save-current-buffer
      (mvc-call-process-and-set-buffer-temporary status-buffer
						 program-name
						 (list "showconfig"))
      (goto-char (point-min))
      (if (re-search-forward "^paths.default-push=\\(.+\\)" nil t)
	  (setq path (match-string 1))
	(when (re-search-forward "^paths.default=\\(.+\\)" nil t)
	  (setq path (match-string 1))))
      (kill-buffer (current-buffer)))
    (mvc-async-push-pull-core status-buffer 'push command-list path "to")))

(defun mvc-async-push-git ()
  (let ((command-list (list "push"))
	(path "?")
	(program-name mvc-l-status-program-name)
	(status-buffer (current-buffer))
	(status-default-directory default-directory))
    (mvc-async-push-pull-core status-buffer 'push command-list path "to")))

(defun mvc-async-push-bazaar ()
  (let ((command-list (list "push"))
	(path "?")
	(program-name mvc-l-status-program-name)
	(status-buffer (current-buffer))
	(status-default-directory default-directory))
    (mvc-async-push-pull-core status-buffer 'push command-list path "to")))

(defun mvc-async-push ()
  (if mvc-l-status-process-process
      (message mvc-message-process-already-running)
    (cond ((eq mvc-l-status-program 'mercurial)
	   (mvc-async-push-mercurial))
	  ((eq mvc-l-status-program 'git)
	   (mvc-async-push-git))
	  ((eq mvc-l-status-program 'bazaar)
	   (mvc-async-push-bazaar))
	  ((eq mvc-l-status-program 'subversion)
	   (message "UNSUPPORTED"))
	  ((eq mvc-l-status-program 'cvs)
	   (message "UNSUPPORTED"))
	  (t
	   (message "UNKNOWN PROGRAM!")))))

(defun mvc-async-pull-mercurial ()
  (let ((command-list (list "pull"))
	(path "?")
	(program-name mvc-l-status-program-name)
	(status-buffer (current-buffer)))
    (save-current-buffer
      (mvc-call-process-and-set-buffer-temporary status-buffer
						 program-name
						 (list "showconfig"))
      (goto-char (point-min))
      (when (re-search-forward "^paths.default=\\(.+\\)" nil t)
	(setq path (match-string 1)))
      (kill-buffer (current-buffer)))
    (mvc-async-push-pull-core status-buffer 'pull command-list path "from")))

(defun mvc-async-pull-bazaar ()
  (let ((command-list (list "pull"))
	(path "?")
	(program-name mvc-l-status-program-name)
	(status-buffer (current-buffer)))
    (save-current-buffer
      (mvc-call-process-and-set-buffer-temporary status-buffer
						 program-name
						 (list "info"))
      (goto-char (point-min))
      (when (re-search-forward "^ +parent branch: \\(.+\\)" nil t)
	(setq path (match-string 1)))
      (kill-buffer (current-buffer)))
    (mvc-async-push-pull-core status-buffer 'pull command-list path "from")))

(defun mvc-async-pull-git ()
  (let ((command-list (list "fetch"))
	(path "?")
	(program-name mvc-l-status-program-name)
	(status-buffer (current-buffer))
	(status-default-directory default-directory))
    (mvc-async-push-pull-core status-buffer 'pull command-list path "from")))

(defun mvc-async-pull ()
  (if mvc-l-status-process-process
      (message mvc-message-process-already-running)
    (cond ((eq mvc-l-status-program 'mercurial)
	   (mvc-async-pull-mercurial))
	  ((eq mvc-l-status-program 'git)
	   (mvc-async-pull-git))
	  ((eq mvc-l-status-program 'bazaar)
	   (mvc-async-pull-bazaar))
	  ((eq mvc-l-status-program 'subversion)
	   (message "UNSUPPORTED"))
	  ((eq mvc-l-status-program 'cvs)
	   (message "UNSUPPORTED"))
	  (t
	   (message "UNKNOWN PROGRAM!")))))




;;; mvc-status-mode

(defun mvc-status-mode-get-branch-name ()
  (let ((branch "notfound"))
    (save-current-buffer
      (mvc-call-process-and-set-buffer-temporary (current-buffer)
						 mvc-l-status-mvc-program-name
						 (list "--" mvc-l-status-program-name "mvcbranch"))
      (when (> (- (point-max) (point-min)) 0)
	  (setq branch (buffer-substring (point-min) (1- (point-max)))))
      (kill-buffer (current-buffer)))
    branch))

(defmacro mvc-status-mode-display-setting (flag-p value directory-regexp-list)
  `(catch 'mapc
     (mapc #'(lambda (path)
	       (when (or (string-match path default-directory)
			 (string-match path (expand-file-name default-directory)))
		 (setq ,flag-p ,value)
		 (throw 'mapc nil)))
	   ,directory-regexp-list)))

(defun mvc-status-mode (initial-program)
  "M(enu|ulti) Version Control Interface"

  (when initial-program
    (kill-all-local-variables)
    (use-local-map mvc-status-mode-map)
    (setq mode-name mvc-mode-name-status)
    (setq major-mode 'mvc-status-mode)

    (set (make-local-variable 'mvc-l-status-program) initial-program)
    (set (make-local-variable 'mvc-l-status-program-name) (cdr (assq mvc-l-status-program mvc-program-name)))
    (set (make-local-variable 'mvc-l-status-mvc-program-name) mvc-mvc-program-name)
    (set (make-local-variable 'mvc-l-status-command-no-argument-p) (eq 'git initial-program))
    (set (make-local-variable 'mvc-l-status-strict-p) mvc-mvc-default-status-strict-p)
    (set (make-local-variable 'mvc-l-status-recursive-p) t)
    (catch 'mapc
      (mapc #'(lambda (path)
		(when (or (string-match path default-directory)
			  (string-match path (expand-file-name default-directory)))
		  (setq mvc-l-status-recursive-p nil)
		  (setq mvc-l-status-strict-p nil)
		  (throw 'mapc nil)))
	    mvc-default-status-fast-directory-regexp-list))
    (let ((base (concat "*mvc-"
			(cdr (assq mvc-l-status-program mvc-program-display-name)))))
      (set (make-local-variable 'mvc-l-status-buffer-name-list)
	   (list (cons 'status-base (concat base "-status*"))
		 (cons 'status (mvc-create-buffer-name (concat base "-status*") default-directory))
		 (cons 'diff (mvc-create-buffer-name (concat base "-diff*") default-directory))
		 (cons 'log (mvc-create-buffer-name (concat base "-log*") default-directory))
		 (cons 'commitlog (mvc-create-buffer-name (concat base "-commitlog*") default-directory))
		 (cons 'result (mvc-create-buffer-name (concat base "-result*") default-directory))
		 (cons 'especial (mvc-create-buffer-name (concat base "-especial*") default-directory))
		 (cons 'add (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'annotate (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'commit (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'remove (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'rename (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'revert (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'process-temporary (mvc-create-buffer-name (concat base "-PROCESS-temporary*") default-directory))
		 (cons 'process-async (mvc-create-buffer-name (concat base "-PROCESS-async*") default-directory))
		 (cons 'process-command (mvc-create-buffer-name (concat base "-PROCESS-command*") default-directory)))))

    (mvc-status-update-header-line)

    (set (make-local-variable 'mvc-l-status-timer) nil)
    (set (make-local-variable 'mvc-l-status-timer-counter) 0)
    (set (make-local-variable 'mvc-l-status-timer-last-mode-line-string) "")
    (set (make-local-variable 'mvc-l-status-timer-last-point) 0)
    (set (make-local-variable 'mvc-l-status-first-point-set-p) nil)
    (set (make-local-variable 'mvc-l-status-ready-p) nil)
    (set (make-local-variable 'mvc-l-status-process-process) nil)
    (set (make-local-variable 'mvc-l-status-process-buffer-name) "")
    (set (make-local-variable 'mvc-l-status-process-last-command) "")
    (set (make-local-variable 'mvc-l-status-process-parameter) nil)
    (set (make-local-variable 'mvc-l-status-last-execute-time-status) nil)
    (set (make-local-variable 'mvc-l-status-last-execute-time-update) nil)
    (set (make-local-variable 'mvc-l-status-last-execute-time-commit) nil)
    (set (make-local-variable 'mvc-l-status-last-execute-time-push) nil)
    (set (make-local-variable 'mvc-l-status-last-execute-time-pull) nil)
    (set (make-local-variable 'mvc-l-status-mvcstatus-header-rawstatus) 0)
    (set (make-local-variable 'mvc-l-status-mvcstatus-header-information) "")
    (make-local-variable 'mvc-l-status-save-load-point)
    (make-local-variable 'mvc-l-status-save-load-file-name)
    (make-local-variable 'mvc-l-status-save-load-window-point-hash)
    (make-local-variable 'mvc-l-status-save-load-window-file-name-hash)
    (make-local-variable 'mvc-l-status-save-load-window-extension-hash)
    (make-local-variable 'mvc-l-status-save-load-file-list-end-point)
    (make-local-variable 'mvc-l-status-save-load-buffer-list)
    (make-local-variable 'mvc-l-status-files)
    (set (make-local-variable 'mvc-l-status-display-unknown-p) mvc-default-status-display-unknown)
    (make-local-variable 'mvc-l-status-display-unknown-masks)
    (set (make-local-variable 'mvc-l-status-display-unmodified-p) mvc-default-status-display-unmodified)
    (make-local-variable 'mvc-l-status-display-unmodified-masks)
    (set (make-local-variable 'mvc-l-status-display-backup-p) mvc-default-status-display-backup)
    (make-local-variable 'mvc-l-status-display-backup-masks)
    (set (make-local-variable 'mvc-l-status-display-ignore-p) mvc-default-status-display-ignore)
    (make-local-variable 'mvc-l-status-display-ignore-masks)
    (set (make-local-variable 'mvc-l-status-display-delete-p) mvc-default-status-display-delete)
    (make-local-variable 'mvc-l-status-display-delete-masks)

    (mvc-status-mode-display-setting mvc-l-status-display-unknown-p
				     nil
				     mvc-default-status-display-unknown-nil-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-unknown-p
				     t
				     mvc-default-status-display-unknown-t-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-unmodified-p
				     nil
				     mvc-default-status-display-unmodified-nil-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-unmodified-p
				     t
				     mvc-default-status-display-unmodified-t-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-backup-p
				     nil
				     mvc-default-status-display-backup-nil-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-backup-p
				     t
				     mvc-default-status-display-backup-t-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-ignore-p
				     nil
				     mvc-default-status-display-ignore-nil-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-ignore-p
				     t
				     mvc-default-status-display-ignore-t-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-delete-p
				     nil
				     mvc-default-status-display-delete-nil-directory-regexp-list)
    (mvc-status-mode-display-setting mvc-l-status-display-delete-p
				     t
				     mvc-default-status-display-delete-t-directory-regexp-list)

    (set (make-local-variable 'mvc-l-status-file-list-begin-point) (point-min))
    (set (make-local-variable 'mvc-l-status-file-list-end-point) (point-max))

    (set (make-local-variable 'mvc-l-status-marks) 0)
    (set (make-local-variable 'mvc-l-status-mark-hash) (make-hash-table :test 'equal))
    (set (make-local-variable 'mvc-l-status-code-hash) (make-hash-table :test 'equal))
    (set (make-local-variable 'mvc-l-status-type-hash) (make-hash-table :test 'equal))
    (set (make-local-variable 'mvc-l-status-information-hash) (make-hash-table :test 'equal))
    (set (make-local-variable 'mvc-l-status-point-hash) (make-hash-table :test 'equal))
    (set (make-local-variable 'mvc-l-status-after-save-hook-hash) (make-hash-table :test 'equal))
    (set (make-local-variable 'mvc-l-status-last-window-configuration) nil)
    (set (make-local-variable 'mvc-l-status-branch-name) (mvc-status-mode-get-branch-name))
    (set (make-local-variable 'mvc-l-status-file-name-list-git-stage-count) 0)
    (set (make-local-variable 'mvc-l-status-file-name-list-git-rename-count) 0)
    (set (make-local-variable 'mvc-l-status-file-name-list-working-directory-count) 0)
    (set (make-local-variable 'mvc-l-status-diff-paramter) nil)

    (set (make-local-variable 'mvc-l-status-cheat-sheet-processes) 0)

    (add-hook 'kill-buffer-hook 'mvc-status-kill-buffer-hook))

  (when mvc-default-use-animation-timer
    (unless mvc-l-status-timer
      (setq mvc-l-status-timer (run-at-time "0 sec" 0.2 'mvc-status-timer-function (current-buffer)))))

  (run-hooks 'mvc-status-mode-hook)
  t)

(defun mvc-status-mode-mkdir (directory)
  "mkdir"
  (interactive "FCreate directory: ")

  (make-directory directory))

(defun mvc-status-mode-find-file ()
  "find-file"
  (interactive)

  (let ((cursor-file-name (mvc-status-get-current-line-file-name)))
    (if cursor-file-name
	(find-file cursor-file-name)
      (message "unknown line!"))))

(defun mvc-status-mode-view-file ()
  "view-file"
  (interactive)

  (let ((cursor-file-name (mvc-status-get-current-line-file-name)))
    (if cursor-file-name
	(view-file cursor-file-name)
      (message "unknown line!"))))

(defun mvc-status-mode-next ()
  "next"
  (interactive)

  (let ((column (current-column)))
    (forward-line)
    (move-to-column column)))

(defun mvc-status-mode-previous ()
  "previous"
  (interactive)

  (let ((column (current-column)))
    (forward-line -1)
    (move-to-column column)))

(defun mvc-status-mode-next-button-search ()
  (let ((candidates (point-max))
	tmp)
    (setq tmp (text-property-any (point) (point-max) 'face 'mvc-face-button-active))
    (when (and tmp (> candidates tmp))
      (setq candidates tmp))
    (setq tmp (text-property-any (point) (point-max) 'face 'mvc-face-button-inactive))
    (when (and tmp (> candidates tmp))
      (setq candidates tmp))
    (setq tmp (text-property-any (point) (point-max) 'face 'mvc-face-toggle-button-inactive))
    (when (and tmp (> candidates tmp))
      (setq candidates tmp))
    (setq tmp (text-property-any (point) (point-max) 'face 'mvc-face-toggle-button-active))
    (when (and tmp (> candidates tmp))
      (setq candidates tmp))
    (if (= candidates (point-max))
	nil
      candidates)))

(defun mvc-status-mode-next-button ()
  "next button"
  (interactive)

  (let ((p (next-single-property-change (point) 'face (current-buffer))))
    (if p
	(goto-char p)
      (goto-char (point-min)))
    (setq p (mvc-status-mode-next-button-search))
    (if p
	(goto-char p)
      (goto-char (point-min))
      (setq p (mvc-status-mode-next-button-search))
      (when p
	(goto-char p)))))

(defun mvc-status-mode-next-status ()
  "next status"
  (interactive)

  (when (>= (length mvc-status-buffer-list) 2)
    (let* ((last (1- (length mvc-status-buffer-list)))
	   (i last)
	   (previous last)
	   buffer)
      (while (and (>= i 0)
		  (setq buffer (nth i mvc-status-buffer-list)))
	(when (eq (current-buffer) buffer)
	  (setq previous (1- i)))
	(setq i (1- i)))
      (if (>= previous 0)
	  (switch-to-buffer (nth previous mvc-status-buffer-list))
	(switch-to-buffer (nth last mvc-status-buffer-list))))))

(defun mvc-status-mode-previous-status ()
  "previous status"
  (interactive)

  (when (>= (length mvc-status-buffer-list) 2)
    (let ((i 0)
	  (next 0)
	  buffer)
      (while (setq buffer (nth i mvc-status-buffer-list))
	(when (eq (current-buffer) buffer)
	  (setq next (1+ i)))
	(setq i (1+ i)))
      (if (nth next mvc-status-buffer-list)
	  (switch-to-buffer (nth next mvc-status-buffer-list))
	(switch-to-buffer (nth 0 mvc-status-buffer-list))))))

(defun mvc-status-mode-beginning-of-list ()
  "beginning-of-list"
  (interactive)
  ;; 先頭は固定位置なので常に実行可能
  (mvc-status-beginning-of-list))

(defun mvc-status-mode-end-of-list ()
  "end-of-list"
  (interactive)
  ;; 末尾の位置は可変だけど、常に point-max から -13 でもいいような気はする。一応可能ならば正規の手段で移動しておくが。
  (if (mvc-status-async-p)
      (progn
	(goto-char (point-max))
	(forward-line -13))
    (mvc-status-end-of-list)))

(defun mvc-status-mode-toggle-display-unknown ()
  "toggle display unknown"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-display-unknown-p (not mvc-l-status-display-unknown-p))

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-toggle-display-unmodified ()
  "toggle display unmodified"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-display-unmodified-p (not mvc-l-status-display-unmodified-p))

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-toggle-display-backup ()
  "toggle display backup"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-display-backup-p (not mvc-l-status-display-backup-p))

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-toggle-display-ignore ()
  "toggle display ignore"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-display-ignore-p (not mvc-l-status-display-ignore-p))

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-toggle-display-delete ()
  "toggle display delete"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-display-delete-p (not mvc-l-status-display-delete-p))

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-toggle-recursive ()
  "toggle status recursive"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (if (eq mvc-l-status-program 'subversion)
	(progn
	  (setq mvc-l-status-recursive-p (not mvc-l-status-recursive-p))

	  (mvc-status-draw-with-save-load-point))
      (message "recursive control unsupported"))))

(defun mvc-status-mode-toggle-strict-or-fast ()
  "toggle strict or fast"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-strict-p (not mvc-l-status-strict-p))
    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-toggle-command-no-argument ()
  "toggle command no argument recursive"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-command-no-argument-p (not mvc-l-status-command-no-argument-p))
    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark ()
  "mark"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (let ((cursor-file-name (mvc-status-get-current-line-file-name-with-prefix)))
      (if cursor-file-name
	  (progn
	    (unless (gethash cursor-file-name mvc-l-status-mark-hash)
	      (setq mvc-l-status-marks (1+ mvc-l-status-marks)))
	    (puthash cursor-file-name "*" mvc-l-status-mark-hash)
	    (goto-char (gethash cursor-file-name mvc-l-status-point-hash))
	    (setq buffer-read-only nil)
	    (delete-char 1)
	    (insert "*")
	    (setq buffer-read-only t)
	    (forward-line)
	    (mvc-status-redraw-footer-marks))
	(message "file-name not found")))))

(defun mvc-status-mode-unmark ()
  "unmark"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (let ((cursor-file-name (mvc-status-get-current-line-file-name-with-prefix)))
      (if cursor-file-name
	  (progn
	    (when (gethash cursor-file-name mvc-l-status-mark-hash)
	      (setq mvc-l-status-marks (1- mvc-l-status-marks)))
	    (puthash cursor-file-name nil mvc-l-status-mark-hash)
	    (goto-char (gethash cursor-file-name mvc-l-status-point-hash))
	    (setq buffer-read-only nil)
	    (delete-char 1)
	    (insert " ")
	    (setq buffer-read-only t)
	    (forward-line)
	    (mvc-status-redraw-footer-marks))
	(message "file-name not found")))))

(defun mvc-status-mode-unmark-all ()
  "unmark all"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (setq mvc-l-status-marks 0)
    (maphash #'(lambda (key value)
		 (puthash key nil mvc-l-status-mark-hash))
	     mvc-l-status-mark-hash)

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark-unknown ()
  "mark unknown"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (maphash #'(lambda (key value)
		 (when (string= (gethash key mvc-l-status-code-hash) "?")
		   (unless (string= value "*")
		     (when (not (and (not mvc-l-status-display-backup-p)
				     (mvc-backup-file-p key)))
		       (setq mvc-l-status-marks (1+ mvc-l-status-marks))
		       (puthash key "*" mvc-l-status-mark-hash)))))
	     mvc-l-status-mark-hash)

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark-add ()
  "mark add"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (maphash #'(lambda (key value)
		 (when (string= (gethash key mvc-l-status-code-hash) "A")
		   (unless (string= value "*")
		     (setq mvc-l-status-marks (1+ mvc-l-status-marks))
		     (puthash key "*" mvc-l-status-mark-hash))))
	     mvc-l-status-mark-hash)

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark-remove ()
  "mark remove"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (maphash #'(lambda (key value)
		 (when (string= (gethash key mvc-l-status-code-hash) "D")
		   (unless (string= value "*")
		     (setq mvc-l-status-marks (1+ mvc-l-status-marks))
		     (puthash key "*" mvc-l-status-mark-hash))))
	     mvc-l-status-mark-hash)

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark-modified ()
  "mark modified"
  (interactive)

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (maphash #'(lambda (key value)
		 (when (string= (gethash key mvc-l-status-code-hash) "M")
		   (unless (string= value "*")
		     (setq mvc-l-status-marks (1+ mvc-l-status-marks))
		     (puthash key "*" mvc-l-status-mark-hash))))
	     mvc-l-status-mark-hash)

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark-path-regexp-core (arg)
  "mark path regexp"

  (if (mvc-status-async-p)
      (message mvc-message-process-already-running)
    (let ((regexp (completing-read (if arg
				       "unmark regexp: "
				     "mark regexp: ")
				   '(("Makefile$")
				     ("\.cpp$")))))
      (maphash #'(lambda (key value)
		   (when (string-match regexp key)
		     (if arg
			 (when (string= value "*")
			   (setq mvc-l-status-marks (1- mvc-l-status-marks))
			   (puthash key nil mvc-l-status-mark-hash))
		       (unless (string= value "*")
			 (setq mvc-l-status-marks (1+ mvc-l-status-marks))
			 (puthash key "*" mvc-l-status-mark-hash)))))
	       mvc-l-status-mark-hash))

    (mvc-status-draw-with-save-load-point)))

(defun mvc-status-mode-mark-path-regexp (arg)
  "mark path regexp"
  (interactive "P")

  (mvc-status-mode-mark-path-regexp-core arg))

(defun mvc-status-mode-unmark-path-regexp (arg)
  "unmark path regexp"
  (interactive "P")

  (mvc-status-mode-mark-path-regexp-core (not arg)))

(defun mvc-status-mode-push ()
  "push"
  (interactive)

  (mvc-async-push))

(defun mvc-status-mode-pull ()
  "pull"
  (interactive)

  (mvc-async-pull))

(defun mvc-status-mode-add ()
  "add"
  (interactive)

  (mvc-command-add))

(defun mvc-status-mode-annotate ()
  "annotate"
  (interactive)

  (mvc-command-annotate))

(defun mvc-status-mode-commit ()
  "commit"
  (interactive)

  (if (string= mvc-l-status-branch-name "master")
      (if (yes-or-no-p "Current branch is \"master\". Are you sure you want to commit?")
	  (mvc-command-commit)
	(message "canceled!"))
    (mvc-command-commit)))

(defun mvc-status-mode-log (arg)
  "log"
  (interactive "P")

  (let ((log-buffer-name (cdr (assq 'log mvc-l-status-buffer-name-list))))
    (when (mvc-command-log arg)
      (switch-to-buffer-other-window log-buffer-name))))

(defun mvc-status-mode-revert ()
  "revert"
  (interactive)

  (mvc-command-revert))

(defun mvc-status-mode-status ()
  "status"
  (interactive)

  (mvc-async-status))

(defun mvc-status-mode-remove ()
  "remove"
  (interactive)

  (mvc-command-remove))

(defun mvc-status-mode-quit ()
  "quit"
  (interactive)

  (if (yes-or-no-p (concat "quit? "))
      (progn
	(mapc #'(lambda (a)
		  (when (and (get-buffer (cdr a))
			     (not (eq (car a) 'status)))
		    (kill-buffer (cdr a))))
	      mvc-l-status-buffer-name-list)
	(let (new-list first after)
	  (catch 'mapc
	    (mapc #'(lambda (a)
		      (when (and (not (eq a (current-buffer)))
				 (string-match "^\\*mvc-[^-]+-status\\*" (buffer-name a)))
			(setq first a)
			(throw 'mapc nil)))
		  (buffer-list)))
	  (kill-buffer (cdr (assq 'status mvc-l-status-buffer-name-list)))
	  (when first
	    (switch-to-buffer first))))
    (message "canceled!")))

(defun mvc-status-mode-rename (file-name)
  "rename"
  (interactive (let ((insert-default-directory nil)
  		     (files (length (mvc-command-get-current-or-mark-file-name-list nil))))
  		 (list (if (<= files 1)
			   (read-file-name (format "rename \"%s\" to: " (mvc-status-get-current-line-file-name)))
			 (read-file-name (format "rename %d files to: " files))))))

  (mvc-command-rename file-name))

(defun mvc-status-mode-update ()
  "update"
  (interactive)

  (if (eq mvc-l-status-program 'git)
      (message "UNSUPPORTED")
    (mvc-async-update)))

(defun mvc-status-mode-ediff-only-current (arg)
  "ediff"
  (interactive "P")
  (cond ((and (mvc-command-diff-ediff-p)
	      (or (eq mvc-l-status-program 'mercurial)
		  (eq mvc-l-status-program 'git)
		  (eq mvc-l-status-program 'subversion)
		  (eq mvc-l-status-program 'bazaar)))
	 (mvc-command-diff-ediff))
	(t
	 (let ((diff-buffer-name (cdr (assq 'diff mvc-l-status-buffer-name-list))))
	   (mvc-command-diff-only-current arg)))))

(defun mvc-status-mode-diff-only-current (arg)
  "diff"
  (interactive "P")

  (mvc-command-diff-only-current arg))

(defun mvc-status-mode-diff-current-or-mark (arg)
  "diff"
  (interactive "P")

  (mvc-command-diff-current-or-mark arg))

(defun mvc-status-mode-cheat-sheet ()
  "cheat-sheet"
  (interactive)

  (save-current-buffer
    (mvc-cheat-sheet)))

(defun mvc-status-mode-especial ()
  "especial"
  (interactive)

  (let ((program mvc-l-status-program)
	(file-name-list (mvc-command-get-current-or-mark-file-name-list nil))
	(status-buffer (current-buffer))
	especial-buffer-name)
    (with-current-buffer status-buffer
      (setq especial-buffer-name (cdr (assq 'especial mvc-l-status-buffer-name-list))))
    (cond ((eq program 'mercurial)
	   (message "UNSUPPORTED"))
	  ((eq program 'git)
	   (message "UNSUPPORTED"))
	  ((eq program 'bazaar)
	   (message "UNSUPPORTED"))
	  ((eq program 'subversion)
	   (if file-name-list
	       (progn
		 (pop-to-buffer (get-buffer-create especial-buffer-name))
		 (mvc-especial-mode status-buffer)

		 (mvc-especial-mode-draw-internal status-buffer)
		 (goto-char (point-min))
		 (re-search-forward "^SET" nil t)
		 (beginning-of-line))
	     (when (get-buffer especial-buffer-name)
	       (kill-buffer especial-buffer-name))
	     (message "especial failed (no target file)")))
	  ((eq program 'cvs)
	   (message "UNSUPPORTED"))
	  (t
	   (message "UNKNOWN PROGRAM!")))))

(defun mvc-status-mode-cancel-process ()
  "cancel-process"
  (interactive)
  (when mvc-l-status-process-process
    (delete-process mvc-l-status-process-process)))




;;; mvc-commitlog-mode

(defun mvc-commitlog-mode-done-callback-commit ()
  (let ((commitlog-buffer (current-buffer)) async-p)
    (with-current-buffer mvc-l-commitlog-mode-buffer-name-status
      (setq async-p (mvc-status-async-p)))
    (if async-p
	(message mvc-message-process-already-running)
      (let ((tmpfile (make-temp-name (concat mvc-default-tmp-directory "/mvcel")))
	    commitlog-buffer-name)
	(with-current-buffer mvc-l-commitlog-mode-buffer-name-status
	  (setq commitlog-buffer-name (cdr (assq 'commitlog mvc-l-status-buffer-name-list))))
	(if mvc-default-commitlog-file-coding-system
	    (let ((buffer-file-coding-system mvc-default-commitlog-file-coding-system))
	      (with-temp-file tmpfile
		(insert-buffer-substring commitlog-buffer-name)))
	  (with-temp-file tmpfile
	    (insert-buffer-substring commitlog-buffer-name)))
	(with-current-buffer mvc-l-commitlog-mode-buffer-name-status
	  (setq mvc-l-status-process-parameter `((tmpfile . ,tmpfile)
						 (last-input-event . ,last-input-event)
						 (commitlog-buffer . ,commitlog-buffer)))
	  (mvc-command-current-or-mark (lambda (status-buffer)
					 (with-current-buffer status-buffer
					   (let ((tmpfile (cdr (assq 'tmpfile mvc-l-status-process-parameter))))
					     (setq mvc-l-status-last-execute-time-commit (current-time))
					     (delete-file tmpfile)
					     (mvc-async-status)
					     (when (eq last-input-event (cdr (assq 'last-input-event mvc-l-status-process-parameter)))
					       (set-window-configuration mvc-l-status-last-window-configuration))
					     (save-current-buffer
					       (save-selected-window
						 (switch-to-buffer-other-window (get-buffer-create (cdr (assq 'result mvc-l-status-buffer-name-list))))
						 (mvc-show-call-process-temporary-result status-buffer)))
					     (with-current-buffer (cdr (assq 'commitlog-buffer mvc-l-status-process-parameter))
					       (fundamental-mode)))))
				       nil 'commit nil nil tmpfile))))))

(defun mvc-commitlog-mode (status-buffer &optional done-callback)
  (interactive)

  (kill-all-local-variables)
  (use-local-map mvc-commitlog-mode-map)
  (setq mode-name mvc-mode-name-commitlog)
  (setq major-mode 'mvc-commitlog-mode)

  (set (make-local-variable 'mvc-l-commitlog-mode-buffer-name-status) (buffer-name status-buffer))
  (set (make-local-variable 'mvc-l-commitlog-mode-done-callback) (if done-callback
								     done-callback
								   (lambda () (mvc-commitlog-mode-done-callback-commit))))

  (message "\\C-c\\C-c to commit")

  (run-hooks 'mvc-commitlog-mode-hook))

(defun mvc-commitlog-mode-done ()
  (interactive)

  (funcall mvc-l-commitlog-mode-done-callback))




;;; mvc-log-mode

(defun mvc-log-mode-match-revision-line (limit)
  (let (regex)
    (with-current-buffer mvc-l-log-mode-buffer-name-status
      (cond ((eq 'hg mvc-l-status-program)
	     (setq regex "^\\([^:]+\\): +[0-9]+:\\([0-9a-f]+\\)$"))
	    ((eq 'git mvc-l-status-program)
	     (setq regex "^[\\*\\|\\\\ ]*\\(commit\\) +\\([0-9a-f]+\\)"))
	    ((eq 'bazaar mvc-l-status-program)
	     (setq regex "^\\(r\\)\\([0-9]+\\) +|"))
	    ((eq 'subversion mvc-l-status-program)
	     (setq regex "^\\(revno\\): \\([0-9]+\\)"))))
    (re-search-forward regex limit t)))

(defun mvc-log-mode-match-revision-line-backward (limit)
  (let (regex)
    (with-current-buffer mvc-l-log-mode-buffer-name-status
      (cond ((eq 'hg mvc-l-status-program)
	     (setq regex "^\\([^:]+\\): +[0-9]+:\\([0-9a-f]+\\)$"))
	    ((eq 'git mvc-l-status-program)
	     (setq regex "^[\\*\\|\\\\ ]*\\(commit\\) +\\([0-9a-f]+\\)"))
	    ((eq 'bazaar mvc-l-status-program)
	     (setq regex "^\\(r\\)\\([0-9]+\\) +|"))
	    ((eq 'subversion mvc-l-status-program)
	     (setq regex "^\\(revno\\): \\([0-9]+\\)"))))
    (re-search-backward regex limit t)))

(defun mvc-log-mode (status-buffer)
  (interactive)

  (kill-all-local-variables)
  (use-local-map mvc-log-mode-map)
  (setq mode-name mvc-mode-name-log)
  (setq major-mode 'mvc-log-mode)
  (setq buffer-read-only nil)

  (set (make-local-variable 'mvc-l-log-mode-buffer-name-status) (buffer-name status-buffer))

  (let ((start-float-time (float-time)))
    (save-excursion
      (goto-char (point-min))
      (while (and (mvc-log-mode-match-revision-line nil)
		  (< (- (float-time) start-float-time) mvc-default-log-face-limit-float-time))
	(beginning-of-line)
	(let ((start (point)))
	  (forward-line)
	  (backward-char 1)
	  (set-text-properties start (point) (list 'face 'mvc-face-log-revision))))))

  (setq buffer-read-only t)

  (run-hooks 'mvc-log-mode-hook))

(defun mvc-log-mode-next ()
  (interactive)

  (let ((backup (point)))
    (forward-line)
    (if (not (mvc-log-mode-match-revision-line nil))
	(goto-char backup)
      (beginning-of-line)
      (recenter 0))))

(defun mvc-log-mode-previous ()
  (interactive)

  (mvc-log-mode-match-revision-line-backward nil)
  (beginning-of-line)
  (recenter 0))

(defun mvc-log-mode-return ()
  (interactive)

  (let ((flag t))
    (with-current-buffer mvc-l-log-mode-buffer-name-status
      (when (and (nth 0 (mvc-command-get-current-or-mark-file-name-list nil))
		 (string= "." (nth 0 (mvc-command-get-current-or-mark-file-name-list nil))))
	(setq flag (yes-or-no-p "Really cat \".\" all files?"))))
    (if flag
	(save-excursion
	  (let ((limit (point)))
	    (end-of-line)
	    (setq limit (point))
	    (beginning-of-line)
	    (if (mvc-log-mode-match-revision-line limit)
		(let ((key (match-string 1))
		      (revision (match-string 2)))
		  (with-current-buffer mvc-l-log-mode-buffer-name-status
		    (mvc-call-process-and-set-buffer-temporary (current-buffer)
							       mvc-l-status-mvc-program-name
							       (append (list "--" mvc-l-status-program-name "cat" (concat "--revision=" revision))
								       (mvc-command-get-current-or-mark-file-name-list nil))))
		  (mvc-show-call-process-temporary-result mvc-l-log-mode-buffer-name-status t)
		  (goto-char (point-min))
		  (cond ((string= key "changeset")
			 (message (concat "Mercurial revision " revision)))
			((string= key "commit")
			 (message (concat "Git revision " revision)))
			((string= key "r")
			 (message (concat "Subversion revision " revision)))
			((string= key "revno")
			 (message (concat "Bazaar revision " revision)))
			(t
			 (message "UNKNOWN PROGRAM!!"))))
	      (message "not found"))))
      (message "canceled!"))))

(defun mvc-log-mode-diff ()
  (interactive)

  (save-excursion
    (let ((limit (point)))
      (end-of-line)
      (setq limit (point))
      (beginning-of-line)
      (if (mvc-log-mode-match-revision-line limit)
	  (let ((key (match-string 1))
		(revision (match-string 2)))
	    (with-current-buffer mvc-l-log-mode-buffer-name-status
	      (if (eq 'git mvc-l-status-program)
		  (setq mvc-l-status-diff-paramter (concat revision "~ " revision))
		(setq mvc-l-status-diff-paramter (concat (cdr (assq mvc-l-status-program mvc-default-diff-option-list))
							 revision)))
	      (mvc-command-diff-only-current "")
	      (setq mvc-l-status-diff-paramter nil)))
	(message "not found")))))

(defun mvc-log-mode-cheat-sheet ()
  (interactive)
  (with-current-buffer mvc-l-log-mode-buffer-name-status
    (mvc-cheat-sheet)))

(defun mvc-log-mode-status-mode-next-status ()
  (interactive)

  (with-current-buffer mvc-l-log-mode-buffer-name-status
    (mvc-status-mode-next-status)))

(defun mvc-log-mode-status-mode-previous-status ()
  (interactive)

  (with-current-buffer mvc-l-log-mode-buffer-name-status
    (mvc-status-mode-previous-status)))




;;; mvc-especial-mode

(defun mvc-especial-mode (status-buffer)
  (interactive)

  (kill-all-local-variables)
  (use-local-map mvc-especial-mode-map)
  (setq mode-name mvc-mode-name-especial)
  (setq major-mode 'mvc-especial-mode)

  (set (make-local-variable 'mvc-l-especial-mode-buffer-name-status) (buffer-name status-buffer))
  (set (make-local-variable 'mvc-l-especial-mode-prop-recursive-p) nil)

  (run-hooks 'mvc-especial-mode-hook))

(defun mvc-especial-mode-insert-toggle-svn-recursive ()
  (mvc-status-insert-toggle-button mvc-l-especial-mode-prop-recursive-p
				   "recursive enabled "
				   "recursive disabled"
				   'mvc-especial-mode-toggle-svn-recursive)
  (insert "  propset/propdel --recursive\n"))

(defun mvc-especial-mode-draw-internal-insert-all-file-name-list (file-name-list)
  (catch 'mapc
    (let ((loop 0))
      (mapc #'(lambda (a)
		(setq loop (1+ loop))
		(when (> loop 3)
		  (mvc-insert-with-face " ..." 'mvc-face-especial-path)
		  (throw 'mapc nil))
		(mvc-insert-with-face (concat " " a) 'mvc-face-especial-path))
	    file-name-list)))
  (insert "\n"))

(defun mvc-especial-mode-draw-internal (status-buffer)
  (let (file-name-list
	program
	temporary-process-buffer-name)
    (with-current-buffer status-buffer
      (setq file-name-list (mvc-command-get-current-or-mark-file-name-list nil))
      (setq program mvc-l-status-program)
      (setq temporary-process-buffer-name (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))))
    (setq buffer-read-only nil)
    (erase-buffer)

    (insert "mvc especial (Subversion property) mode\n\n")

    (mapc #'(lambda (a)
	      (mvc-especial-insert-button (nth 0 a) (nth 2 a))
	      (insert (concat "  " (nth 1 a) "\n")))
	  (cdr (assq program mvc-default-especial-list)))
    (mvc-especial-mode-insert-toggle-svn-recursive)

    (insert "================\n")
    (when (>= (length file-name-list) 2)
      (mvc-especial-insert-button "SET ALL"
				  'mvc-especial-mode-svn-propset
				  (cons 'path file-name-list))
      (mvc-especial-mode-draw-internal-insert-all-file-name-list file-name-list)
      (mvc-especial-insert-button "DEL ALL"
				  'mvc-especial-mode-svn-propdel
				  (cons 'path file-name-list))
      (mvc-especial-mode-draw-internal-insert-all-file-name-list file-name-list))
    (mapc #'(lambda (a)
	      (mvc-especial-insert-button "SET"
					  'mvc-especial-mode-svn-propset
					  (cons 'path (list a)))
	      (insert " ")
	      (mvc-insert-with-face (concat a "\n") 'mvc-face-especial-path)
	      (with-current-buffer status-buffer
		(mvc-call-process-and-set-buffer-temporary status-buffer
							   mvc-l-status-program-name
							   (list "proplist"
								 a))
		(goto-char (point-min))
		(save-excursion
		  (while (and (= (forward-line) 0)
			      (char-after))
		    (re-search-forward " +\\(.+\\)" nil t)
		    (let ((property (match-string 1)))
		      (beginning-of-line)
		      (insert "        ")
		      (mvc-especial-insert-button "GET"
						  'mvc-especial-mode-svn-propget
						  (cons 'path a)
						  (cons 'property property))
		      (insert " ")
		      (mvc-especial-insert-button "SET"
						  'mvc-especial-mode-svn-propset
						  (cons 'path (list a))
						  (cons 'property property))
		      (insert " ")
		      (mvc-especial-insert-button "DEL"
						  'mvc-especial-mode-svn-propdel
						  (cons 'path (list a))
						  (cons 'property property)))))
		(delete-region (point) (progn
					 (forward-line)
					 (point))))
	      (insert-buffer-substring temporary-process-buffer-name))
	  file-name-list)
    (kill-buffer temporary-process-buffer-name)
    (insert "================\n")
    (insert (format "%4d file(s)\n" (length file-name-list)))

    (setq buffer-read-only t)

    (message "especial ...done")))

(defun mvc-especial-mode-draw ()
  "draw"
  (interactive)

  (let (program
	file-name-list
	(status-buffer (get-buffer mvc-l-especial-mode-buffer-name-status))
	especial-buffer-name)
    (with-current-buffer status-buffer
      (setq program mvc-l-status-program)
      (setq file-name-list (mvc-command-get-current-or-mark-file-name-list nil))
      (setq especial-buffer-name (cdr (assq 'especial mvc-l-status-buffer-name-list))))
    (cond ((eq program 'mercurial)
	   (message "UNSUPPORTED"))
	  ((eq program 'git)
	   (message "UNSUPPORTED"))
	  ((eq program 'bazaar)
	   (message "UNSUPPORTED"))
	  ((eq program 'subversion)
	   (if file-name-list
	       (progn
		 (let (backup-recursive-p)
		   (when (get-buffer especial-buffer-name)
		     (with-current-buffer especial-buffer-name
		       (setq backup-recursive-p mvc-l-especial-mode-prop-recursive-p)))
		   (pop-to-buffer (get-buffer-create especial-buffer-name))
		   (mvc-especial-mode status-buffer)
		   (when backup-recursive-p
		     (setq mvc-l-especial-mode-prop-recursive-p backup-recursive-p)))
		 (mvc-especial-mode-draw-internal status-buffer)
		 (goto-char (point-min))
		 (re-search-forward "^SET" nil t)
		 (beginning-of-line))
	     (when (get-buffer especial-buffer-name)
	       (kill-buffer especial-buffer-name))
	     (message "especial failed (no target file)")))
	  ((eq program 'cvs)
	   (message "UNSUPPORTED"))
	  (t
	   (message "UNKNOWN PROGRAM!")))))

(defun mvc-especial-insert-button (label function &optional property-a property-b)
  (let ((map (copy-keymap mvc-especial-mode-map))
	(start (point)))
    (define-key map [mouse-1] function)
    (define-key map "\C-m" function)
    (mvc-insert-with-face label
			  'mvc-face-button-active)
    (when property-a
      (put-text-property start
			 (point)
			 (car property-a) (cdr property-a)))
    (when property-b
      (put-text-property start
			 (point)
			 (car property-b) (cdr property-b)))
    (put-text-property start
		       (point)
		       'local-map map)))

(defun mvc-especial-mode-next ()
  "next"
  (interactive)

  (let ((p (next-single-property-change (point) 'face (current-buffer))))
    (if p
	(goto-char p)
      (goto-char (point-min)))
    (setq p (text-property-any (point) (point-max) 'face 'mvc-face-button-active))
    (if p
	(goto-char p)
      (goto-char (point-min))
      (setq p (text-property-any (point) (point-max) 'face 'mvc-face-button-active))
      (when p
	(goto-char p)))))

(defun mvc-especial-mode-previous-previous (loop)
  (let (p)
    (while (> loop 0)
      (setq loop (1- loop))
      (setq p (previous-single-property-change (point) 'face))
      (when p
	(goto-char p)))))

(defun mvc-especial-mode-previous ()
  "previous"
  (interactive)

  (let ((p (previous-single-property-change (point) 'face (current-buffer))))
    (if p
	(progn
	  (goto-char p)
	  (if (get-text-property p 'face)
	      (mvc-especial-mode-previous-previous 2)
	    (mvc-especial-mode-previous-previous 1)))
      (goto-char (point-max))
      (mvc-especial-mode-previous-previous 2))))

(defun mvc-especial-mode-call-process-temporary (status-buffer arg-list)
  (with-current-buffer status-buffer
    (mvc-call-process-and-set-buffer-temporary status-buffer
					       mvc-l-status-program-name
					       arg-list)))

(defun mvc-especial-mode-puthash-and-draw-status (status-buffer path)
  (with-current-buffer status-buffer
    (mapc #'(lambda (a)
	      (puthash (concat (expand-file-name default-directory) a) "m" mvc-l-status-after-save-hook-hash))
	  path)
    (mvc-status-draw-with-save-load-point)))

(defun mvc-especial-mode-svn-add-ignore ()
  "svn set ignore"
  (interactive)

  (let ((start-column (current-column))
	(status-buffer-name mvc-l-especial-mode-buffer-name-status)
	(prop-recursive-p mvc-l-especial-mode-prop-recursive-p))
    (mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
					      (list "propget"
						    "--strict"
						    "svn:ignore"
						    "."))
    (mvc-especial-mode-puthash-and-draw-status (get-buffer status-buffer-name) (list "."))
    (let ((add-length 0)
	  current-or-mark-list
	  temporary-process-buffer-name)
      (with-current-buffer status-buffer-name
	(setq current-or-mark-list (mvc-command-get-current-or-mark-file-name-list nil))
	(setq temporary-process-buffer-name (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))))
      (mapc #'(lambda (a)
		(save-excursion
		  (if (string= a ".")
		      (message (concat "\".\" cannot set ignore"))
		    (with-current-buffer temporary-process-buffer-name
		      (goto-char (point-min))
		      (if (re-search-forward (concat "^" (regexp-quote a) "$") nil t)
			  (message (concat "    ignore already:" a))
			(setq add-length (1+ add-length))
			(insert (concat a "\n")))))))
	    current-or-mark-list)
      (if (> add-length 0)
	  (progn
	    (mvc-show-call-process-temporary-result (get-buffer status-buffer-name) t)
	    (mvc-especial-commit-mode (get-buffer status-buffer-name) "svn:ignore" (list ".") nil start-column prop-recursive-p)
	    (message (format "\"\\C-c\\C-c\" to set ignore %d file(s)" add-length)))
	(message "propset failed (no target file)")))))

(defun mvc-especial-mode-svn-remove-ignore ()
  "svn remove ignore"
  (interactive)

  (let ((start-column (current-column))
	(status-buffer-name mvc-l-especial-mode-buffer-name-status)
	(prop-recursive-p mvc-l-especial-mode-prop-recursive-p))
    (mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
					      (list "propget"
						    "--strict"
						    "svn:ignore"
						    "."))
    (mvc-especial-mode-puthash-and-draw-status (get-buffer status-buffer-name) (list "."))
    (let ((remove-length 0)
	  current-or-mark-list
	  temporary-process-buffer-name)
      (with-current-buffer status-buffer-name
	(setq current-or-mark-list (mvc-command-get-current-or-mark-file-name-list nil))
	(setq temporary-process-buffer-name (cdr (assq 'process-temporary mvc-l-status-buffer-name-list))))
      (mapc #'(lambda (a)
		(save-excursion
		  (if (string= a ".")
		      (message (concat "\".\" cannot remove ignore"))
		    (with-current-buffer temporary-process-buffer-name
		      (goto-char (point-min))
		      (if (re-search-forward (concat "^" (regexp-quote a) "$") nil t)
			  (progn
			    (setq remove-length (1+ remove-length))
			    (replace-match "")
			    (delete-blank-lines))
			(message (concat "    ignore yet:" a)))))))
	    current-or-mark-list)
      (if (> remove-length 0)
	  (progn
	    (mvc-show-call-process-temporary-result (get-buffer status-buffer-name) t)
	    (mvc-especial-commit-mode (get-buffer status-buffer-name) "svn:ignore" (list ".") nil start-column prop-recursive-p)
	    (message (format "\"\\C-c\\C-c\" to remove ignore %d file(s)" remove-length)))
	(message "propdel failed (no target file)")))))

(defun mvc-especial-mode-svn-propget ()
  "svn propget"
  (interactive)

  (let ((status-buffer-name mvc-l-especial-mode-buffer-name-status))
    (mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
					      (list "propget"
						    "--strict"
						    (get-text-property (point) 'property)
						    (get-text-property (point) 'path)))
    (mvc-show-call-process-temporary-result (get-buffer status-buffer-name))))

(defun mvc-especial-mode-reset-cursor (property path start-column)
  (goto-char (point-min))
  (re-search-forward (concat "^SET +" (regexp-quote (nth 0 path)) "$") nil t)
  (let (limit)
    (save-excursion
      (if (re-search-forward "^SET +.+" nil t)
	  (progn
	    (beginning-of-line)
	    (setq limit (point)))
	(setq limit (point-max))))
    (if (re-search-forward (concat "^ +GET +SET +DEL +" (regexp-quote property) "$") limit t)
	(progn
	  (beginning-of-line)
	  (goto-char (+ (point) start-column)))
      (beginning-of-line))))

(defun mvc-especial-mode-svn-propset (arg)
  "svn propset"
  (interactive "P")

  (let ((property (get-text-property (point) 'property))
	(path-list (get-text-property (point) 'path))
	(start-point (point))
	(start-column (current-column))
	(status-buffer-name mvc-l-especial-mode-buffer-name-status)
	(prop-recursive-p mvc-l-especial-mode-prop-recursive-p)
	value)
    (unless property
      (setq property (completing-read (if mvc-l-especial-mode-prop-recursive-p
					  "property RECURSIVE: "
					"property: ")
				      '(("svn:ignore")
					("svn:keywords")
					("svn:executable")
					("svn:eol-style")
					("svn:mime-type")
					("svn:externals")
					("svn:needs-lock")))))
    (unless arg
      (cond ((or (string= property "svn:executable")
		 (string= property "svn:needs-lock"))
	     (setq value "*"))
	    ((string= property "svn:keywords")
	     (setq value (completing-read "property value: " '(("URL") ("HeadURL")
							       ("Author") ("LastChangedBy")
							       ("Date") ("LastChangedDate")
							       ("Rev") ("Revision") ("LastChangedRevision")
							       ("Id")))))
	    ((string= property "svn:eol-style")
	     (setq value (completing-read "property value: " '(("native")
							       ("LF")
							       ("CR")
							       ("CRLF")))))
	    ((string= property "svn:mime-type")
	     (setq value (completing-read "property value: " '(("application/")
							       ("binary/")
							       ("text/")))))))
    (if (or arg
	    (not value))
	(progn
	  (mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
						    (append (list "propget" "--strict" property)
							    path-list))
	  (mvc-show-call-process-temporary-result (get-buffer status-buffer-name) t)
	  (mvc-especial-commit-mode (get-buffer status-buffer-name) property path-list start-point start-column prop-recursive-p)
	  (setq buffer-read-only nil)
	  (message (format "\"\\C-c\\C-c\" to propset")))
      (when value
	(mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
						  (if prop-recursive-p
						      (append (list "propset" "--recursive" property value)
							      path-list)
						    (append (list "propset" property value)
							    path-list)))
	(if prop-recursive-p
	    (progn
	      (with-current-buffer status-buffer-name
		(mvc-async-status)))
	  (mvc-especial-mode-puthash-and-draw-status (get-buffer status-buffer-name) path-list))
	(mvc-show-call-process-temporary-result (get-buffer status-buffer-name))
	(mvc-especial-mode-draw-internal (get-buffer status-buffer-name))
	(if (= (length path-list) 1)
	    (mvc-especial-mode-reset-cursor property path-list start-column)
	  (goto-char start-point))))))

(defun mvc-especial-mode-svn-propdel ()
  "svn propdel"
  (interactive)

  (let ((path-list (get-text-property (point) 'path))
	(property (get-text-property (point) 'property))
	(start-point (point))
	(start-column (current-column))
	(status-buffer-name mvc-l-especial-mode-buffer-name-status))
    (unless property
      (setq property (completing-read (if mvc-l-especial-mode-prop-recursive-p
					  "property RECURSIVE: "
					"property: ")
				      '(("svn:ignore")
					("svn:keywords")
					("svn:executable")
					("svn:eol-style")
					("svn:mime-type")
					("svn:externals")
					("svn:needs-lock")))))
    (if (yes-or-no-p (concat (if mvc-l-especial-mode-prop-recursive-p
				 "propdel RECURSIVE? "
			       "propdel? ")))
	(progn
	  (mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
						    (if mvc-l-especial-mode-prop-recursive-p
							(append (list "propdel" "--recursive" property)
								path-list)
						      (append (list "propdel" property)
							      path-list)))
	  (if mvc-l-especial-mode-prop-recursive-p
	      (progn
		(with-current-buffer status-buffer-name
		  (mvc-async-status)))
	    (mvc-especial-mode-puthash-and-draw-status (get-buffer status-buffer-name) path-list))
	  (mvc-show-call-process-temporary-result (get-buffer status-buffer-name))
	  (mvc-especial-mode-draw-internal (get-buffer status-buffer-name))
	  (if (= (length path-list) 1)
	      (mvc-especial-mode-reset-cursor property path-list start-column)
	    (goto-char start-point)))
      (message "canceled!"))))

(defun mvc-especial-mode-toggle-svn-recursive ()
  "toggle svn recursive"
  (interactive)

  (let ((status-buffer-name mvc-l-especial-mode-buffer-name-status)
	window-point-list)
    (if mvc-l-especial-mode-prop-recursive-p
	(setq mvc-l-especial-mode-prop-recursive-p nil)
      (setq mvc-l-especial-mode-prop-recursive-p t))
    (mapc #'(lambda (a)
	      (setq window-point-list (append window-point-list (list (cons a (window-point a))))))
	  (get-buffer-window-list (current-buffer) t))
    (save-excursion
      (goto-char (point-min))
      (search-forward "recursive")
      (beginning-of-line)
      (setq buffer-read-only nil)
      (let ((point (point)))
	(end-of-line)
	(delete-region point (1+ (point))))
      (mvc-especial-mode-insert-toggle-svn-recursive)
      (setq buffer-read-only t))
    (mapc #'(lambda (a)
	      (set-window-point (car a) (cdr a)))
	  window-point-list)))




;;; mvc-especial-commit-mode

(defun mvc-especial-commit-mode (status-buffer property path-list start-point start-column prop-recursive-p)
  (interactive)

  (kill-all-local-variables)
  (use-local-map mvc-especial-commit-mode-map)
  (setq mode-name mvc-mode-name-especial-commit)
  (setq major-mode 'mvc-especial-commit-mode)

  (set (make-local-variable 'mvc-l-especial-commit-mode-buffer-name-status) (buffer-name status-buffer))
  (set (make-local-variable 'mvc-l-especial-commit-mode-property) property)
  (set (make-local-variable 'mvc-l-especial-commit-mode-path-list) path-list)
  (set (make-local-variable 'mvc-l-especial-commit-mode-start-point) start-point)
  (set (make-local-variable 'mvc-l-especial-commit-mode-start-column) start-column)
  (set (make-local-variable 'mvc-l-especial-commit-mode-prop-recursive-p) prop-recursive-p)

  (run-hooks 'mvc-especial-commit-mode-hook))

(defun mvc-especial-commit-mode-done ()
  "svn proplist"
  (interactive)

  (let ((property mvc-l-especial-commit-mode-property)
	(path-list mvc-l-especial-commit-mode-path-list)
	(start-point mvc-l-especial-commit-mode-start-point)
	(start-column mvc-l-especial-commit-mode-start-column)
	(status-buffer-name mvc-l-especial-commit-mode-buffer-name-status))
    (let ((tmpfile (make-temp-name (concat mvc-default-tmp-directory "/mvcel")))
	  result-buffer-name)
      (with-current-buffer status-buffer-name
	(setq result-buffer-name (cdr (assq 'result mvc-l-status-buffer-name-list))))
      (if mvc-default-commitlog-file-coding-system
	  (let ((buffer-file-coding-system mvc-default-commitlog-file-coding-system))
	    (with-temp-file tmpfile
	      (insert-buffer-substring result-buffer-name)))
	(with-temp-file tmpfile
	  (insert-buffer-substring result-buffer-name)))
      (mvc-especial-mode-call-process-temporary (get-buffer status-buffer-name)
						(if mvc-l-especial-commit-mode-prop-recursive-p
						    (append (list "propset" "--recursive" property)
							    path-list
							    (list "--file" tmpfile))
						  (append (list "propset" property)
							  path-list
							  (list "--file" tmpfile))))
      (mvc-especial-mode-puthash-and-draw-status (get-buffer status-buffer-name) path-list)
      (delete-file tmpfile))

    (fundamental-mode)

    (mvc-show-call-process-temporary-result (get-buffer status-buffer-name))

    (let (especial-buffer-name)
      (with-current-buffer status-buffer-name
	(setq especial-buffer-name (cdr (assq 'especial mvc-l-status-buffer-name-list))))
      (switch-to-buffer-other-window (get-buffer-create especial-buffer-name)))
    (mvc-especial-mode-draw-internal (get-buffer status-buffer-name))
    (if (= (length path-list) 1)
	(mvc-especial-mode-reset-cursor property path-list start-column)
      (goto-char start-point))))




;;; mvc-cheat-sheet-mode

(defun mvc-cheat-sheet-mode (status-buffer)
  (interactive)

  (kill-all-local-variables)
  (use-local-map mvc-cheat-sheet-mode-map)
  (let (branch-name)
    (with-current-buffer status-buffer
      (setq branch-name mvc-l-status-branch-name))
    (setq mode-name (concat mvc-mode-name-cheat-sheet " " branch-name)))
  (setq major-mode 'mvc-cheat-sheet-mode)

  (set (make-local-variable 'mvc-l-cheat-sheet-mode-status-buffer) status-buffer)
  (set (make-local-variable 'comment-start) "#")

  (run-hooks 'mvc-cheat-sheet-mode-hook))

(defun mvc-cheat-sheet-mode-run-process-filter (process string)
  (with-current-buffer (process-buffer process)
    (goto-char (point-max))
    (insert string)                              
    (when (get-buffer-window (current-buffer))
      (forward-line (* -1 (- (window-height (selected-window)) 2)))
      (set-window-point (get-buffer-window (current-buffer)) (point-max)))))

(defun mvc-cheat-sheet-mode-run-process-sentinel (process event)
  (with-current-buffer (process-buffer process)
    (when (string= " command async" mode-line-process)
      (setq mode-line-process nil))

    (with-current-buffer local-status-buffer
      (setq mvc-l-status-cheat-sheet-processes (1- mvc-l-status-cheat-sheet-processes))
      (mvc-status-mode-status))

    (cond ((or (string-match "^finished" event)
	       (string-match "^exited abnormally with code" event))
	   (when local-goto-min
	     (goto-char (point-min)))
	   (let ((return-window local-return-window))
	     ;; 
	     ;; mode change (kill-all-local-variables)
	     ;; 
	     (cond ((string= "diff-mode" local-mode)
		    (diff-mode))
		   ((string= "mvc-log-mode" local-mode)
		    (mvc-log-mode local-status-buffer)))
	     ;; 
	     ;; window change
	     ;; 
	     (when return-window
	       (select-window return-window))))
	  (t
	   (message (concat "process error error:" event))))))

(defun mvc-cheat-sheet-mode-run-commitlog-mode-done-callback-commit ()
  (let ((commitlog-buffer (current-buffer))
	async-p
	command
	async-process-buffer-name
	process
	backup-window
	(status-buffer mvc-l-commitlog-mode-buffer-name-status))
    (with-current-buffer mvc-l-commitlog-mode-buffer-name-status
      (setq async-p (mvc-status-async-p))
      (setq command (cdr (assq 'command mvc-l-status-process-parameter)))
      (setq async-process-buffer-name (cdr (assq 'async-process-buffer-name mvc-l-status-process-parameter)))
      (setq process (cdr (assq 'process mvc-l-status-process-parameter)))
      (setq backup-window (cdr (assq 'backup-window mvc-l-status-process-parameter))))
    (if async-p
	(message mvc-message-process-already-running)
      (let ((tmpfile (make-temp-name (concat mvc-default-tmp-directory "/mvcel")))
	    commitlog-buffer-name)
	(with-current-buffer mvc-l-commitlog-mode-buffer-name-status
	  (setq commitlog-buffer-name (cdr (assq 'commitlog mvc-l-status-buffer-name-list))))
	(if mvc-default-commitlog-file-coding-system
	    (let ((buffer-file-coding-system mvc-default-commitlog-file-coding-system))
	      (with-temp-file tmpfile
		(insert-buffer-substring commitlog-buffer-name)))
	  (with-temp-file tmpfile
	    (insert-buffer-substring commitlog-buffer-name)))
	(with-current-buffer mvc-l-commitlog-mode-buffer-name-status

	  (setq command (replace-regexp-in-string "%commitlog" tmpfile command))
	  (setq async-process-buffer-name (cdr (assq 'process-command mvc-l-status-buffer-name-list)))
	  (with-current-buffer (get-buffer-create async-process-buffer-name)
	    (erase-buffer)
	    (kill-all-local-variables)

	    (setq process (start-process-shell-command async-process-buffer-name
						       async-process-buffer-name
						       command))
	    (set (make-local-variable 'local-status-buffer) status-buffer)
	    (set (make-local-variable 'local-return-window) backup-window)
	    (set (make-local-variable 'local-goto-min) t)
	    (set (make-local-variable 'local-process) process)
	    (set (make-local-variable 'local-mode) nil))
	  (setq mvc-l-status-cheat-sheet-processes (1+ mvc-l-status-cheat-sheet-processes))
	  (set-process-sentinel process 'mvc-cheat-sheet-mode-run-process-sentinel)
	  (switch-to-buffer-other-window async-process-buffer-name))))))

;; #@*-begin
;; #@*-end
;; で囲まれていれば ("#@*-begin" "command") のリストを、囲まれていなければ nil を返します。
(defun mvc-cheat-sheet-mode-run-get-region-special-begin-and-command ()
  (let (special-begin special-end command-start command)
    (save-excursion
      (when (string-match "^#@.+-begin$" (buffer-substring (line-beginning-position) (line-end-position)))
	(end-of-line))
      (when (re-search-backward "^#@" nil t)
	(setq special-begin (buffer-substring (line-beginning-position) (line-end-position)))
	(when (string-match ".-begin$" special-begin)
	  (forward-line 1)
	  (setq command-start (point))
	  (when (re-search-forward "^#@" nil t)
	    (setq special-end (buffer-substring (line-beginning-position) (line-end-position)))
	    (when (string-match ".-end$" special-end)
	      (beginning-of-line)
	      (setq command (buffer-substring command-start (point)))
	      (list special-begin command))))))))

;; 現在の行が #@ の次か #@ と同じならば ("#@*" "command") のリストを、そうでなければ nil を返します。
(defun mvc-cheat-sheet-mode-run-get-special-and-command ()
  (let (tmp special command)
      (save-excursion
	(setq tmp (buffer-substring (line-beginning-position) (line-end-position)))
	(if (string-match "^#@" tmp)
	    (progn
	      (setq special tmp)
	      (forward-line 1)
	      (setq command (buffer-substring (line-beginning-position) (line-end-position)))
	      (list special command))
	  (forward-line -1)
	  (setq special (buffer-substring (line-beginning-position) (line-end-position)))
	  (when (and (string-match "^#@" special)
		     (not (string-match ".-end$" special)))
	    (setq command tmp)
	    (list special command))))))

(defun mvc-cheat-sheet-mode-run-start-process (special command async-process-buffer-name sentinel status-buffer backup-window)
  (let (process)
    (with-current-buffer (get-buffer-create async-process-buffer-name)
      (setq buffer-read-only nil)
      (erase-buffer)

      (kill-all-local-variables)
      (use-local-map mvc-cheat-sheet-process-mode-map)
      (setq mode-name mvc-mode-name-cheat-sheet-process)
      (setq major-mode 'mvc-cheat-sheet-mode-process)

      (unless mode-line-process
	(setq mode-line-process " command async"))
      (setq process (start-process-shell-command async-process-buffer-name
						 async-process-buffer-name
						 command))
      (set (make-local-variable 'local-status-buffer) status-buffer)
      (set (make-local-variable 'local-return-window) backup-window)
      (set (make-local-variable 'local-goto-min) nil)
      (set (make-local-variable 'local-process) process)
      (set (make-local-variable 'local-mode) nil)
      (cond ((or (string-match "diff-mode" special)
		 (string-match "\s*[^ ]+\s+diff" command))
	     (setq local-mode "diff-mode"))
	    ((or (string-match "mvc-log-mode" special)
		 (string-match "\s*[^ ]+\s+log" command))
	     (setq local-mode "mvc-log-mode"))))
    (setq mvc-l-status-cheat-sheet-processes (1+ mvc-l-status-cheat-sheet-processes))
    (set-process-sentinel process sentinel)
    (set-process-filter process 'mvc-cheat-sheet-mode-run-process-filter)
    (switch-to-buffer-other-window async-process-buffer-name)))

(defun mvc-cheat-sheet-mode-run ()
  "mvc-cheat-sheet-mode-run"
  (interactive)

  (let ((special "")
	command
	special-list
	eval-region-list)
    (setq eval-region-list (mvc-cheat-sheet-mode-run-get-region-special-begin-and-command))
    (if eval-region-list
	(progn
	  (setq special (nth 0 eval-region-list))
	  (setq command (nth 1 eval-region-list)))
      (setq special-list (mvc-cheat-sheet-mode-run-get-special-and-command))
      (if special-list
	  (progn
	    (setq special (nth 0 special-list))
	    (setq command (nth 1 special-list)))
	(setq command (buffer-substring (line-beginning-position) (line-end-position)))))
    (with-current-buffer mvc-l-cheat-sheet-mode-status-buffer
      (when (string-match "%mvc" command)
	(setq command (replace-match (concat mvc-l-status-mvc-program-name " -- " mvc-l-status-program-name) t nil command)))
      (when (string-match "%program" command)
	(setq command (replace-match mvc-l-status-program-name t nil command)))
      (when (string-match "%files" command)
	(let ((concat-file-name-list (mapconcat #'(lambda (a)
						    a)
						(mvc-command-get-current-or-mark-file-name-list nil)
						" ")))
	  (if concat-file-name-list
	      (setq command (replace-match concat-file-name-list t nil command))
	    (setq command ""))))
      (when (string-match "%file" command)
	(let ((file-name-list (mvc-command-get-current-or-mark-file-name-list t)))
	  (if file-name-list
	      (setq command (replace-match (nth 0 file-name-list) t nil command))
	    (setq command "")))))

    (if (and (string-match "^[ \t]*#" command)
	     (not (string-match "^#@script-eval" special)))
	(message "comment line!")
      (if (yes-or-no-p (concat "run \"" command "\" ?"))
	  (with-current-buffer mvc-l-cheat-sheet-mode-status-buffer
	    (let ((status-buffer (current-buffer))
		  async-process-buffer-name
		  backup-window)
	      (unless (string-match "no-return-window" special)
		(setq backup-window (selected-window)))
	      (cond ((string-match "^#@elisp-eval" special)
		     (with-temp-buffer
		       (insert command)
		       (eval-buffer)))
		    ((string-match "^#@script-eval" special)
		     (setq async-process-buffer-name (mvc-create-buffer-name "*mvc-cheat-sheet-script-process*" default-directory))
		     (let ((tmpfile (make-temp-name (concat mvc-default-tmp-directory "/mvcel-script"))))
		       (with-temp-file tmpfile
			 (insert command))
		       (set-file-modes tmpfile 448) ; 0700
		       (puthash tmpfile t mvc-cheat-sheet-tmpfile-hash)
		       (mvc-cheat-sheet-mode-run-start-process special
							       tmpfile
							       async-process-buffer-name 
							       (lambda (process event)
								 (maphash #'(lambda (key value)
								 	      (delete-file key))
								 	  mvc-cheat-sheet-tmpfile-hash)
								 (clrhash mvc-cheat-sheet-tmpfile-hash)
								 (mvc-cheat-sheet-mode-run-process-sentinel process event))
							       status-buffer
							       backup-window)))
		    (t
		     (cond ((string-match "%commitlog" command)
			    (setq mvc-l-status-last-window-configuration (current-window-configuration))
			    (setq mvc-l-status-process-parameter `((command . ,command)
								   (async-process-buffer-name . ,async-process-buffer-name)
								   (backup-window . ,backup-window)))
			    (switch-to-buffer-other-window (get-buffer-create (cdr (assq 'commitlog mvc-l-status-buffer-name-list))))
			    (mvc-commitlog-mode status-buffer (lambda ()
								(mvc-cheat-sheet-mode-run-commitlog-mode-done-callback-commit))))
			   (t
			    (setq async-process-buffer-name (cdr (assq 'process-command mvc-l-status-buffer-name-list)))
			    (mvc-cheat-sheet-mode-run-start-process special
								    command
								    async-process-buffer-name 
								    'mvc-cheat-sheet-mode-run-process-sentinel
								    status-buffer
								    backup-window)))))))
	(message "canceled!")))))

(defun mvc-cheat-sheet-mode-comment ()
  "mvc-cheat-sheet-mode-comment"
  (interactive)
  (if mark-active
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(defun mvc-cheat-sheet-mode-next-status ()
  "mvc-cheat-sheet-mode-next-status"
  (interactive)

  (with-current-buffer mvc-l-cheat-sheet-mode-status-buffer
    (mvc-status-mode-next-status)))

(defun mvc-cheat-sheet-mode-previous-status ()
  "mvc-cheat-sheet-mode-previous-status"
  (interactive)

  (with-current-buffer mvc-l-cheat-sheet-mode-status-buffer
    (mvc-status-mode-previous-status)))

(defun mvc-cheat-sheet-mode-cancel-process ()
  (interactive)
  (with-current-buffer mvc-l-cheat-sheet-mode-status-buffer
    (let ((async-process-buffer-name (cdr (assq 'process-command mvc-l-status-buffer-name-list))))
      (when (and async-process-buffer-name
		 (get-buffer async-process-buffer-name))
	(with-current-buffer (get-buffer async-process-buffer-name)
	  (mvc-cheat-sheet-process-mode-cancel-process))))))

(defun mvc-cheat-sheet-process-mode-cancel-process ()
  (interactive)
  (when local-process
    (delete-process local-process)
    (setq local-process nil)
    (message "PROCESS TERMINATED")))




;;; after-save-hook

(defun mvc-after-save-hook ()
  (when mvc-status-buffer-list
    (mapc #'(lambda (a)
	      (when (string-match "^\\*mvc-[^-]+-status\\*" (buffer-name a))
		(let ((check-file-name buffer-file-name))
		  (with-current-buffer a
		    (let ((dir-regexp (concat "^" (expand-file-name default-directory))))
		      (when (string-match dir-regexp check-file-name)
			(when (and (boundp 'mvc-l-status-buffer-name-list)
				   (string= (cdr (assq 'status mvc-l-status-buffer-name-list)) (buffer-name a)))
			  (let ((cooked-check-file-name (replace-regexp-in-string dir-regexp "" check-file-name)))
			    (unless (catch 'found
				      (maphash #'(lambda (key value)
						   (let ((cooked-key (substring key 2)))
						     (when (string= cooked-key cooked-check-file-name)
						       (throw 'found t))))
					       mvc-l-status-code-hash)
				      nil)
			      (puthash (concat "  " cooked-check-file-name) " " mvc-l-status-code-hash)))
			  (puthash check-file-name "m" mvc-l-status-after-save-hook-hash)
			  (mvc-status-draw-with-save-load-point))))))))
	  (buffer-list))))

(add-hook 'after-save-hook 'mvc-after-save-hook)




(provide 'mvc)
