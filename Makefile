image: 
	go run misc/myconv.go misc/img.png > image.s	
	as main.asm -o image.o
	ld -Ttext 0x7c00 --oformat=binary image.o -o image.img
	rm image.o

do: main.asm
	as main.asm -o image.o
	ld -Ttext 0x7c00 --oformat=binary image.o -o image.img
	rm image.o

run: image
	qemu-system-i386 -nic none -drive format=raw,file=image.img


