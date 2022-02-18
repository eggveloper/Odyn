all: run

build/kernel.bin: build/kernel_entry.o build/kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

build/kernel_entry.o: kernel_entry.s
	nasm $< -f elf64 -o $@

build/kernel.o: kernel/kernel.c
	gcc -ffreestanding -c $< -o $@

build/debug/kernel.dis: build/kernel.bin
	ndisasm -b 32 $< >$@

build/boot.bin: boot.s
	nasm $< -f bin -o $@

build/odyn.bin: build/boot.bin build/kernel.bin
	cat $^ >$@

run: build/odyn.bin