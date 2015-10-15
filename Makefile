
##############################################################################
#
# Create system images
#
##############################################################################
all: boot.s
	nasm -felf32 boot.s -o boot.o
	gcc -T linker.ld -Wl,--build-id=none -o root/ilyssa.bin -ffreestanding -O2 -nostdlib boot.o -m32

# create a new CD image in images/ from the contents of root/
cd-image:
	mkdir -p images/
	echo " IMAGE	images/ilyssa.iso"
	mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot \
		-quiet -boot-load-size 4 -boot-info-table \
		-o images/ilyssa.iso root

# run the emulator to test the system
test:
	qemu-system-x86_64 -cdrom images/ilyssa.iso
