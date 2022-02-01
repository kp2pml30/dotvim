function! neomake#makers#cmake_gcc#cmake_gcc() abort
	let maker = neomake#makers#ft#cpp#gcc()
	return {
		\ 'exe': 'cmake',
		\ 'args': ['--build', 'build'],
		\ 'errorformat': 'Error: %s,' . maker.errorformat
	\ }
endfunction
