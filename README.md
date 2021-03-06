# About

- smart
- simple
- multi VCS support (Git, Mercurial, Subversion and Bazaar)




# Install

- Copy `mvc.el` to your load-path
- Copy `mvc` command to ~/bin
- Edit init.el

```lisp
(require 'mvc)
```




# How to use

## YouTube

[![example](http://img.youtube.com/vi/VGcKGQM3Dlk/0.jpg)](http://www.youtube.com/watch?v=VGcKGQM3Dlk)


## status

* `M-x mvc-status`


### mvc-status-mode

* `a mvc-status-mode-add`

* `b mvc-status-mode-annotate`

* `c mvc-status-mode-commit`

* `g mvc-status-mode-status`

* `l mvc-status-mode-log`

* `r mvc-status-mode-revert` (`git reset HEAD` or `git checkout` (chosen by context))

* `s mvc-status-mode-status`

* `D mvc-status-mode-remove`

* `Q mvc-status-mode-quit`

* `R mvc-status-mode-rename`

* `U mvc-status-mode-update`

* `= mvc-status-mode-diff-only-current`

* `! mvc-status-mode-cheat-sheet`


### mvc-cheat-sheet-mode

`\C-\C` to run command.

```
git log -n 32 --graph --decorate=full
git stash list
git rebase -i HEAD~~~


#@script-eval-begin
#!/usr/bin/perl -w
for (my $i = 0; $i < 3; ++$i) { print "DB $i\n"; }
print "DONE\n";
#@script-eval-end


#@elisp-eval-begin
(message "A")
(message "B")
(message "C")
#@elisp-eval-end
```


## FAQ

### mvc-status is slow!

Add your project path to `mvc-default-status-fast-directory-regexp-list`.

```
(add-to-list 'mvc-default-status-fast-directory-regexp-list "/YOUR-PROJECT-PATH/$")
```
