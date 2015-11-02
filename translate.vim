" File:			translate.vim
" Purpose:		vim plugin for translating word by Youdao
" Date Created:	2015-10-30
" Version:		v0.0

if exists("loaded_translate")
	finish
endif
let loaded_translate = 1

if !has("python")
	echomsg "Error: Required vim compile with python"
	finish
endif

function Translate(word)
	let url = 'http://fanyi.youdao.com/openapi.do?keyfrom=flkclub&key=770083173&type=data&doctype=json&version=1.1&q='.a:word
python << EOF
import vim, urllib2, json
url = vim.eval("url")
ans = urllib2.urlopen(url).read()
json_ans = json.loads(ans)
if json_ans['errorCode']==0:
	vim.command("echo '%s'" % json_ans['translation'][0])
if json_ans.has_key('basic'):
	if json_ans['basic'].has_key('explains'):
		exp = "".join(json_ans['basic']['explains'])
		vim.command("echo '%s'" % exp)
EOF
endfunction

command! -nargs=* Trans call Translate(expand('<cword>'))
nnoremap <silent> t :call Translate(expand('<cword>'))<CR>
