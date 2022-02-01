" kp2pml30

function! myspacevim#WingmanFillHole(type)
	call CocAction('codeAction', a:type, ['refactor.wingman.fillHole'])
	call myspacevim#GotoNextHole()
endfunction

function! myspacevim#JumpToNextHole()
	call CocActionAsync('diagnosticNext', 'hint')
endfunction

function! myspacevim#GotoNextHole()
	" wait for the hole diagnostics to reload
	sleep 500m
	" and then jump to the next hole
	normal 0
	call myspacevim#JumpToNextHole()
endfunction

function! myspacevim#before() abort
	" dirty hacks
	let g:loaded_indent_blankline = 1

	let g:indent_blankline_enabled = 0
	let g:indentLine_enabled = 0
	let g:indent_guides_enable_on_vim_startup = 0

	call SpaceVim#custom#SPCGroupName(['L'], '+LSP')
	call SpaceVim#custom#SPC('nore', ['L', 'd'], 'call CocActionAsync("jumpDefinition")', 'definition', 1)
	call SpaceVim#custom#SPC('nore', ['L', 't'], 'call CocActionAsync("jumpTypeDefinition")', 'jtype', 1)
	call SpaceVim#custom#SPC('nore', ['L', 'x'], 'call CocActionAsync("jumpReferences")', 'refs', 1)
	call SpaceVim#custom#SPC('nore', ['L', 'r'], 'call CocActionAsync("refactor")', 'refactor', 1)
	call SpaceVim#custom#SPC('nore', ['L', 'q'], 'call CocActionAsync("doQuickfix")', 'quickfix', 1)
	call SpaceVim#custom#SPC('nore', ['L', 'a'], 'call CocAction("codeAction")', 'action', 1)
	call SpaceVim#custom#SPCGroupName(['L', 'h'], '+haskell')
	call SpaceVim#custom#SPC('nore', ['L', 'h', 'h'], 'Hoogle', 'hoogle-popup', 1)
	call SpaceVim#custom#SPC('nore', ['L', 'h', 'H'], 'Hoogle!', 'hoogle', 1)
	call SpaceVim#custom#SPC('nore', ['L', 'h', 'f'], 'set operatorfunc=myspacevim#WingmanFillHole<CR>g@l', 'fill hole', 1)
	# nnoremap <silent> <leader>n  :<C-u>set operatorfunc=myspacevim#WingmanFillHole<CR>g@l

	let g:neomake_cpp_enabled_makers=['clangcheck']
	let g:neomake_tempfile_dir='/tmp/neomakebuild%:p:h'

	let g:neomake_java_javac_autoload_gradle_classpath=1
	set list
	" autocmd VimEnter * call myspacevim#opentree()
endfunction

function myspacevim#opentree() abort
	let l:wind = win_getid()
	NERDTree
	TagbarOpen
	call win_gotoid(l:wind)
endfunction

function! myspacevim#after() abort
	" IndentBlanklineDisable!

	if exists(':GuiRenderLigatures')
		GuiRenderLigatures 1
	endif

	au BufRead * normal zR

	autocmd BufWritePost * silent NERDTreeRefreshRoot

	set nu nornu
	set tabpagemax=2
	set tabstop=2
	set shiftwidth=2
	set noexpandtab
	set foldmethod=syntax

	set clipboard=unnamedplus
	" set listchars=tab:→\ ,space:·,nbsp:␣
	set listchars=tab:┆\ ,space:·,nbsp:␣

	map <F2> :w<CR>
	map! q
	imap <F2> <C-O>:w<CR>
	map <C-F2> :wa<CR>
	map <C-q> :Bclose<CR>
	map <A-q> :q<CR>
	map <F7> :Neomake!<CR>
	noremap <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
	imap <Home> <C-o><Home>
	noremap q <Nop>

	map <Leader>h <Home>
	map <Leader>l <End>

	call neomake#configure#automake('rw')

	let NERDTreeShowHidden=1
	if !exists("NERDTreeIgnore")
		let NERDTreeIgnore = []
	endif
	let NERDTreeIgnore += ['\.class$']
	let NERDTreeIgnore += ['^.git$', '^.clangd$']
	if filereadable('./.nvimrc')
		source ./.nvimrc
	endif

	set completeopt=menuone
	try
		set completeopt+=popup
	catch
	endtry
	set noerrorbells
	set novisualbell
endfunction
" set exrc

function! SpacevimClean() abort
	call map(dein#check_clean(), "delete(v:val, 'rf')")
	call dein#recache_runtimepath()
endfunction
