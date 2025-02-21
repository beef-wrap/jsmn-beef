copy jsmn\jsmn.h jsmn\jsmn.c

clang -c -g -gcodeview -o jsmn_d.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall jsmn\jsmn.c

mkdir libs
move jsmn_d.lib libs
