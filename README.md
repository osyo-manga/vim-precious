# precious.vim
-------------

現在のカーソル位置のコンテキストによって filetype を切り換える為のプラグインです。


## Example
----------

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


echo join(range(10), "-")
"------------------------------------------------------------------------------
```

## TODO
-------

* コンテキストの切り替わり時にユーザが自由に処理をフック
* set filetype= 以外への対応
* matcher、switcher を使用した機能の拡張
* matcher、switcher の優先順位付け
* context local な設定を行う
* filetype を切り替えた場合、設定が変わってしまうのでどうにかしたい


