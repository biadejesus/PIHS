as -32 code.s -o code.o
ld -m elf_i386 code.o -l c -dynamic-linker /lib/ld-linux.so.2 -o code
./code