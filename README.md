# LINUX SELLER OS OMG !!!

## Made fully by Alexandr Linux

## Compiling 

dependencies

* binutils

### Linux

```console
$ make
```

### Windows

Unknown. Any suggestions will be accepted

## Running

Possible to run on bare x86 compatible hardware that supports BIOS bootup (x86\_64 also mostly supported)

There are basically two ways of running linux\_sellerOS
1. On bare hardware (To run on bare hardware image must be written to bootup device like USB for example.)
2. In emulator

Both variants will be shown in this "tutorial"

### On Linux

**On bare hardware**

```console
$ dd if=image.img of=<block device to boot of later>
```
Then just boot from that device

**In emulator:**
[Qemu](https://www.qemu.org/) emulator is suggested because OS was built using it.

To run `qemu -drive format=raw,file=image.img`

Qemu installation:
* Debian and debian based: `sudo apt install qemu`
* Void linux: `sudo xbps-install qemu`
* Fedora: `sudo dnf install qemu`
* Gentoo: follow this tutorial [Gentoo Wiki](https://wiki.gentoo.org/wiki/QEMU)
* Red Hat linux: sucks
* Arch linux: `sudo pacman -Suy qemu-full`
* Compiling from source: [github.com/qemu/qemu](https://github.com/qemu/qemu)

### On Windows

**On bare hardware**

It is possible to use [Rufus](https://rufus.ie/en/) in `dd` mode.

**In emulator:**

[Virtualbox](https://www.virtualbox.org/) is suggested because of more user friendly interface.

Comments to VirtualBox emulator environment setup:
1. No HDD space needed, OS runs only in RAM
2. At least 1MB ram memory
3. OS type `Other 32-bit`

[Qemu](https://www.qemu.org/) emulator is suggested because OS was built using it but no tutorial here will be provided.

## Screenshots

![screen1](https://github.com/bebre2288/linux_sellerOS/blob/main/images/screen1.png?raw=true)
![screen2](https://github.com/bebre2288/linux_sellerOS/blob/main/images/screen2.png?raw=true)


