# precious.vim

現在のカーソル位置のコンテキストによって filetype を切り換える為のプラグインです。

Set the buffer filetype based on the code block the cursor currently resides in.

The code block filetype is determined by the [context_filetype.vim](https://github.com/Shougo/context_filetype.vim) plugin.

## Requirement

* [context_filetype.vim](https://github.com/Shougo/context_filetype.vim)
* [vim-textobj-user](https://github.com/kana/vim-textobj-user)
    * `<Plug>(textobj-precious-i)` を使用したい時のみ必要。
* [quickrun.vim](https://github.com/thinca/vim-quickrun)
    * `<Plug>(precious-quickrun-op)` を使用したい時のみ必要。



## Screencapture
![capture](https://f.cloud.github.com/assets/214488/810517/1d435a7c-eeb9-11e2-8b98-b2275db39695.gif)


## Supported
* c
    * masm
    * gas
* cpp
    * masm
    * gas
* d
    * masm
* eruby
    * ruby
* help
    * vim
* html
    * javascript
    * coffee
    * css
* int-nyaos
    * lua
* lua
    * vim
* nyaos
    * lua
* perl16
    * pir
* python
    * vim
* vim
    * python
    * ruby
    * lua
* vimshell
    * vim
* xhtml
    * javascript
    * coffee
    * css
* markdown


## Example

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


" autocmd
" コンテキストに入った時の処理をフック
augroup test
	autocmd!
	autocmd User PreciousFileType      :echo precious#context_filetype()
	" ruby のコンテキストに入った時に tabstop を設定する
	autocmd User PreciousFiletype_ruby :PreciousSetContextLocal tabstop=8
augroup END


" insert mode に入った時に 'filetype' を切り換える。
" カーソル移動時の自動切り替えを無効化
" let g:precious_enable_switch_CursorMoved = {
" \	"*" : 0
" \}
" let g:precious_enable_switch_CursorMoved_i = {
" \	"*" : 0
" \}
" 
" " insert に入った時にスイッチし、抜けた時に元に戻す
" augroup test
" 	autocmd!
" 	autocmd InsertEnter * :PreciousSwitch
" 	autocmd InsertLeave * :PreciousReset
" augroup END


" quickrun.vim との連携
" <Space>qic で quickrun.vim する
" filetype が切り替わってない状態でも
" コンテキストから quickrun.vim で使用する type を決定
" nmap <Space>q <Plug>(precious-quickrun-op)
" omap ic <Plug>(textobj-precious-i)
" vmap ic <Plug>(textobj-precious-i)
"------------------------------------------------------------------------------
```


## Implementations

* コンテキストに入った時に自動的に filetype を切り換える
* コンテキストが切り替わった時に autocmd User で処理がフック出来る
* コンテキストの範囲の textobj に対応
* quickrun.vim との連携
    * コンテキストの範囲を quickrun する
    * filetype が切り替わってない状態でも type を設定


## TODO

* matcher、switcher を使用した機能の拡張
* matcher、switcher の優先順位付け
* コンテキストの範囲を取得


