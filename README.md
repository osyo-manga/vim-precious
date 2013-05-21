#precious.vim

現在のカーソル位置のコンテキストによって filetype を切り換える為のプラグインです。


##Screencapture
![capture](https://github.com/osyo-manga/vim-precious/images/capture.gif)



##Example

```vim
" test.vim
" set filetype=vim --------------------------------------------------
echo "hello, world"


" set filetype=ruby -----------------------------
ruby << EOF

result = (1..10).map(&:to_s).join("-")
puts result

EOF
"---------------------------------------------------------


" set filetype=python ----------------------------
python << EOF

print map(str, range(1, 10))
print "-".join(map(str, range(1, 10)))

EOF
"---------------------------------------------------------


" autocmd
" コンテキストに入った時の処理をフック
augroup test
	autocmd!
	autocmd User PreciousFileType      :echo precious#context_filetype()
	autocmd User PreciousFiletype_ruby :PreciousSetContextLocal tabstop=8
augroup END


echo join(range(10), "-")
"------------------------------------------------------------------------------
```

##TODO

* matcher、switcher を使用した機能の拡張
* matcher、switcher の優先順位付け
* コンテキストの範囲を取得
* quickrun.vim との連携
 * 元の filetype で :QuickRun
 * 現在のコンテキスト範囲を :QuickRun


