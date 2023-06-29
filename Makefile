do: main.asm
	as main.asm -o image.o
	ld -Ttext 0x7c00 --oformat=binary image.o -o image
	rm image.o
	#dd if=image of=bt.img bs=512 count=1
	#hexdump -Cv bt.img
run: do
	qemu-system-i386 -nic none -drive format=raw,file=image
#as main.asm -o boot.o
#gcc -c ccode.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
#i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

