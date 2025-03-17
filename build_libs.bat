mkdir libs
mkdir libs\debug
mkdir libs\release

copy jsmn\jsmn.h jsmn\jsmn.c

clang -c -g -gcodeview -o jsmn.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall jsmn\jsmn.c
move jsmn.lib libs\debug

clang -c -O3 -o jsmn.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall jsmn\jsmn.c
move jsmn.lib libs\release
