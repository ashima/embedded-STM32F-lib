
#include <sys/stat.h>
#include <errno.h>
#include <instances.h>
#include <gpio.h>

extern "C" {
#include <lddefs.h>

extern void _exit(int x);

void _exit(int x) { while (1) {} } 
int _kill (int pid, int sig) { return 0; }
int _getpid() { return 0; }
int _close(int fd) { return 0; }
int _fstat(int fd, struct stat *st) { st->st_mode = S_IFCHR; return 0; }
int _isatty(int fd) { return 1; }
int _lseek(int fd, int o, int dir) { return 0; }
int _open(const char *n, int flags, int mode) { errno = EIO; return -1; }
int _read(int fd, char *buff, int len) { return 0; }
//int _write(int fd, char *buff, int len) { return 0; }
//caddr_t _sbrk(int incr) { errno = ENOMEM; return ((caddr_t)-1); }
 
caddr_t _sbrk_r (struct _reent *r, int i)
  {
  static uint8_t* t = (uint8_t*)0;

  register uint8_t* sp asm ("sp");
  uint8_t *n, *o;

  if ( (uint8_t*)0 == t )
    t = (uint8_t*)&__end__;

  n = t + i;

  if (n > sp)
    {
    errno = ENOMEM;
    o = (uint8_t*) -1;
    }
  else
    {
    o = t;
    t = n;
    }

  return (caddr_t) o;
  }

typedef USART2 cons;

int _write(int file, uint8_t *p, int len)
  {
  int i = 0;

  do
    {
    while (0 == *cons::TXE) {}
    *cons::DR = p[i++];
    *cons::TE = true;
    } while ( i < len );

  return i;
  }
//extern C
}
