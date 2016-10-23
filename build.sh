cd kernel && make || exit 1
cd ..

rm -rf iso neos.iso
mkdir -p iso/boot/grub
cp kernel/neos.bin iso/boot/neos.bin || exit 1
cp kernel/grub.cfg iso/boot/grub/grub.cfg || exit 2
grub-mkrescue -o neos.iso iso
