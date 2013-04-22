
#include <sys/stat.h>
#include <errno.h>
extern void _exit(int x);

void _exit(int x) { while (1) {} } 
int _kill (int pid, int sig) { return 0; }
int _getpid() { return 0; }
int _close(int fd) { return -1; }
int _fstat(int fd, struct stat *st) { st->st_mode = S_IFCHR; return 0; }
int _isatty(int fd) { return 1; }
int _lseek(int fd, int o, int dir) { return 0; }
int _open(const char *n, int flags, int mode) { errno = EIO; return -1; }
int _read(int fd, char *buff, int len) { return 0; }
int _write(int fd, char *buff, int len) { return 0; }
caddr_t _sbrk(int incr) { errno = ENOMEM; return ((caddr_t)-1); }
 

