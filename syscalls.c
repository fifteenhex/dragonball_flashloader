#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>

#include "../headers/uart.h"

#define STDIN_FILENO 0 /* standard input file descriptor */
#define STDOUT_FILENO 1 /* standard output file descriptor */
#define STDERR_FILENO 2 /* standard error file descriptor */

static void uart_putch(int channel, char ch){
        utx1_txdata = ch;
        while(utx1_status & UTX1_STATUS_BUSY){}
}

int _write(int file, char * ptr, int len) {
	if (file == STDOUT_FILENO) {
		for (int pos = 0; pos < len; pos++) {
			uart_putch(0, *ptr++);
		}
		return 0;
	}
	return -1;
}

int _write_r(struct _reent *r, int file, char * ptr, int len) {
	return _write(file, ptr, len);
}

int _read(int file, char * ptr, int len) {
	//uart_putc('r');

	if (file == STDIN_FILENO) {
		// *ptr = uart_getc();
		//  uart_putc(*ptr);
		return 1;
	}

	return 0;

}

int _read_r(struct _reent *r, int file, char * ptr, int len) {
	return _read(file, ptr, len);
}

int _close(int file) {
	//uart_putc('c');
	return 0;
}

int _close_r(struct _reent *r, int file) {
	return _close(file);
}

int _lseek(int file, int ptr, int dir) {
	//uart_putc('l');
	return 0;
}

int _lseek_r(struct _reent *r, int file, int prt, int dir) {
	return _lseek(file, prt, dir);
}

int _isatty(int file) {
	if (file == STDOUT_FILENO) {
		return 1;
	}

	return 0;
}

int _isatty_r(struct _reent *r, int file) {
	return _isatty(file);
}

int _fstat(int file, struct stat * st) {
	if (file == STDOUT_FILENO) {
		memset(st, 0, sizeof(*st));
		st->st_mode = S_IFCHR;
		st->st_blksize = 1024;
		return 0;
	}
	else {
		return (-1);
	}
}

int _fstat_r(void* wtf, int file, struct stat * st) {
	return _fstat(file, st);
}

/* Register name faking - works in collusion with the linker.  */
register char * stack_ptr asm ("sp");

caddr_t _sbrk(int incr) {
	extern char end asm ("end"); /* Defined by the linker.  */
	static char * heap_end;
	char * prev_heap_end;

	if (heap_end == NULL) {
		heap_end = &end;
	}

	prev_heap_end = heap_end;

	if (heap_end + incr > stack_ptr) {
		/* Some of the libstdc++-v3 tests rely upon detecting
		 out of memory errors, so do not abort here.  */
#if 0
		extern void abort (void);
		_write (1, "_sbrk: Heap and stack collision\n", 32);
		abort ();
#else
		errno = ENOMEM;
		return (caddr_t) - 1;
#endif
	}

	heap_end += incr;

	return (caddr_t) prev_heap_end;
}

caddr_t _sbrk_r(struct _reent *r, int incr) {
	return _sbrk(incr);
}
