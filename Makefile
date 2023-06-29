do: main.asm
	as main.asm -o image.o
	ld -Ttext 0x7c00 --oformat=binary image.o -o image.img
	rm image.o
run: do
	qemu-system-i386 -nic none -drive format=raw,file=image.img

