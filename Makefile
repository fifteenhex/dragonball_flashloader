TCPREFIX=../../../toolchains/inst/m68k-elf/bin
CC=$(TCPREFIX)/m68k-elf-gcc 
AS=$(TCPREFIX)/m68k-elf-as
CP=$(TCPREFIX)/m68k-elf-objcopy

AFLAGS=-ahls -m68000
CFLAGS=-mc68000 -ggdb -std=gnu99 -Wall -O2 -Wstrict-aliasing
LFLAGSFLASH=-mc68000 -Tflash.lds -nostartfiles -Wl,-Map=prog.flash.map,--cref
LFLAGSSDRAM=-mc68000 -Tsdram.lds -nostartfiles -Wl,-Map=prog.sdram.map,--cref

all: prog.sdram.bin prog.flash.bin

prog.sdram.bin: prog.sdram.elf
	$(CP) -O binary $< $@

prog.flash.bin: prog.flash.elf
	$(CP) -O binary $< $@

prog.sdram.elf: crt.o main.o syscalls.o sdram.lds
	$(CC) $(LFLAGSSDRAM) -o $@ crt.o main.o syscalls.o

prog.flash.elf: crt.o main.o syscalls.o flash.lds
	$(CC) $(LFLAGSFLASH) -o $@ crt.o main.o syscalls.o

syscalls.o: syscalls.c
	$(CC) $(CFLAGS) -c $^

main.o: main.c
	$(CC) $(CFLAGS) -c $^

crt.o: crt.s
	$(AS) $(AFLAGS) crt.s -o crt.o > crt.lst

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.srec
	rm -f *.map
	rm -f *.elf
	rm -f *.lst
