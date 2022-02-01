function! neomake#makers#cmake_conf#cmake_conf() abort
	"let efm =
	"	\ ' %#%f:%l %#(%m)' .
	"	\ ',%E' . 'CMake Error at %f:%l (message):' .
	"	\ ',%Z' . 'Call Stack (most recent call first):' .
	"	\ ',%C' . ' %m'
	let ef = '%ECMake Error at %f:%l%s,CMake Error%s'
	return {
		\ 'exe': 'cmake',
		\ 'args': ['-G', 'Ninja', '-DCMAKE_BUILD_TYPE=Debug', '-DCMAKE_EXPORT_COMPILE_COMMANDS=On', '-S', '.', '-B', 'build'],
		\ 'errorformat': ef
	\ }
endfunction
