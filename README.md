#precious.vim
-------------

現在のカーソル位置のコンテキストによって filetype を切り換える為のプラグインです。


##Require
---------

* [neocomplcache](https://github.com/Shougo/neocomplcache.vim)


##Example
---------

```
" test.vim
" set filetype=vim --------------------------------------------------
echo "hello, world"


" set filetype=ruby -----------------------------
ruby << REOF

result = (1..10).map(&:to_s).join("-")
puts result

REOF
"---------------------------------------------------------


" set filetype=python ----------------------------
python << PEOF

print map(str, range(1, 10))
print "-".join(map(str, range(1, 10)))

PEOF
"---------------------------------------------------------


echo join(range(10), "-")
"------------------------------------------------------------------------------
```

##TODO
------

* より高度なコンテキストの判定（現状は neocomplcache 依存）
* コンテキストの切り替わり時にユーザが自由に処理をフック
* filetype 以外への対応
* matcher、switcher を使用した機能の拡張
* matcher の優先順位付け
* context local な設定を行う
* filetype を切り替えた場合、設定が変わってしまうのでどうにかしたい


