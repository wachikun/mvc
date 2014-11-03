# mvc.el について

mvc.el は version 0.1 から mvc という外部コマンドを呼び出すようになりました。複雑な処理を外部コマンドに追い出すことで、従来の mvc.el よりも高速でシンプルなコードになっています。

mvc の実行には Perl が必要です。




# インストール

`mvc.el` を `~/.emacs.d/init.el` あたりから読み込めるようにしてと書き、 mvc コマンドをパスの通った場所へコピーすれば完了です。

```lisp
(require 'mvc)
```




# 操作例

## YouTube

[![example](http://img.youtube.com/vi/VGcKGQM3Dlk/0.jpg)](http://www.youtube.com/watch?v=VGcKGQM3Dlk)


## 基本操作

* `M-x mvc-status`


### mvc-status-mode

`mvc.el` の基本的となるモードです。

* `a mvc-status-mode-add`

* `b mvc-status-mode-annotate`

* `c mvc-status-mode-commit`

* `g mvc-status-mode-status`

* `l mvc-status-mode-log`

* `r mvc-status-mode-revert`

* `s mvc-status-mode-status`

* `D mvc-status-mode-remove`

* `Q mvc-status-mode-quit`

* `R mvc-status-mode-rename`

* `U mvc-status-mode-update`

* `= mvc-status-mode-diff-only-current`

* `! mvc-status-mode-cheat-sheet`


### mvc-cheat-sheet-mode

Git で威力を発揮するチートシートモードです。

チートシートのように、メモしておいたコマンドをそのまま実行できます。
