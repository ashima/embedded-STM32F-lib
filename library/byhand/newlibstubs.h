
#include <sys/stat.h>
#include <errno.h>
#include <lddefs.h>


/**
  \brief Default null stub for [lack of] process control
 */

struct procctl_none
  {
  static void exit(int x) { while (1) {} } 
  static int kill (int pid, int sig) { return 0; }
  static int getpid() { return 0; }
  };

/**
  \brief Default null stub for [lack of] file control
 */
struct filectl_none
  {
  static int close(int f)                 { return -1; }
  static int isatty(int f)                { return 1; }
  static int lseek(int f, int o, int d)   { return 0; }
  static int read(int f, char *b, int l)  { return 0; }
  static int write(int f, char *b, int l) { return 0; }

  static int open(const char *n, int flags, int mode)
    { 
    errno = EIO;
    return -1;
    }

  static int fstat(int fd, struct stat *st)
    {
    st->st_mode = S_IFCHR;
    return 0;
    }
  };

/**
  \brief Default null stub for [lack of] process control
 */
struct heapctl_none
  {
  static caddr_t sbrk(int i)
    { 
    errno = ENOMEM;
    return ((caddr_t)-1);
    }
  }; 

/**
  \brief Simplest file control outputing everything to a blocking UART.

  */

template<typename C>
struct filectl_uartonly : public filectl_none
  {
  typedef C cons;

  static int write(int f, char *p, int l)
    {
    int i = 0;
  
    do
      {
      while (0 == *cons::TXE) {}
      *cons::DR = (uint32_t)(p[i++]);
      *cons::TE = true;
      } while ( i < l );
  
    return i;
    }
  };

/**
  \brief Simple incrementing heap control, checking for stack
         colision.
 */

struct heapctl_simple
  {
  static char* sbrk (int i)
    {
    static char* t = (char*)0;
  
    register char* sp asm ("sp");
    char *n, *o;
  
    if ( (char*)0 == t )
      t = (char*)&__end__;
  
    if ( (n = t+i) > sp)
      {
      errno = ENOMEM;
      o = (char*) -1;
      }
    else
      {
      o = t;
      t = n;
      }
  
    return o;
    }
  };


/**
  \brief newblibstub holder class. It agrigates policies for heap
         control, file control and process control.
*/

template<typename HEAPCTL = heapctl_none, 
         typename FILECTL = filectl_none, 
         typename PROCCTL = procctl_none >
struct newlibStubs { 
  // process control
  static void exit(int x)                     {PROCCTL::exit(x); }
  static int kill (int p, int s)              {return PROCCTL::kill(p,s); }
  static int getpid()                         {return PROCCTL::getpid(); }
  // file control
  static int close(int fd)                    {return FILECTL::close(fd); }
  static int fstat(int fd, struct stat *st)   {return FILECTL::fstat(fd,st); }
  static int isatty(int fd)                   {return FILECTL::isatty(fd); }
  static int lseek(int fd, int o, int d)      {return FILECTL::lseek(fd,o,d);}
  static int open(const char *n, int f, int m){return FILECTL::open(n,f,m); }
  static int read(int fd, char *p, int l)     {return FILECTL::read(fd,p,l); }
  static int write(int fd, char *p, int l)    {return FILECTL::write(fd,p,l);}
  // heap control
  static char* sbrk(int i)                    {return HEAPCTL::sbrk(i); }
  };

/**
  \breif  build newlib syscall stubs that bounce staticaly indirect through
          TYPE
  \remark this has to be a macro as functions with extern linkage cannot
          be templated.
*/ 

#define MK_NEWLIB_STUBS(TYPE) typedef TYPE NLSTUB_T ; extern "C" { \
  void _exit(int x)                      { NLSTUB_T::exit(x); while(1){} }   \
  int _kill (int p, int s)               { return NLSTUB_T::kill(p,s); }     \
  int _getpid()                          { return NLSTUB_T::getpid(); }      \
  int _close(int fd)                     { return NLSTUB_T::close(fd); }     \
  int _fstat(int fd, struct stat *st)    { return NLSTUB_T::fstat(fd,st); }  \
  int _isatty(int fd)                    { return NLSTUB_T::isatty(fd); }    \
  int _lseek(int fd, int o, int d)       { return NLSTUB_T::lseek(fd,o,d); } \
  int _open(const char *n, int f, int m) { return NLSTUB_T::open(n,f,m); }   \
  int _read(int fd, char *p, int l)      { return NLSTUB_T::read(fd,p,l); }  \
  int _write(int fd, char *p, int l)     { return NLSTUB_T::write(fd,p,l); } \
  char* _sbrk(int i)                     { return NLSTUB_T::sbrk(i); }       \
  };

 
