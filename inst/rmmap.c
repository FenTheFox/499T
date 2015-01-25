#include "rmmap.h"
#include "logger.h"

#if !defined(__USE_GNU)
#define __USE_GNU	//for mremap
#endif
#include <sys/mman.h>

void *repl_mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
#if !defined(TEST_REPL)
	void *ptr = mmap(addr, length, prot, flags, fd, offset);
#else
	void *ptr = NULL;
#endif

	if (flags & MAP_ANON)
		doLog(MMAP, ptr, length);
	else
		doLog(MMAP, ptr, 0);

	return ptr;
}

void *repl_mremap(void *addr, size_t oldsz, size_t newsz, int flags)
{
#if !defined(TEST_REPL)
	void *ptr = mremap(addr, oldsz, newsz, flags);
#else
	void *ptr = NULL;
#endif

	doLog(MUNMAP, addr, oldsz);
	doLog(MMAP, ptr, newsz);
	return ptr;
}

int repl_munmap(void *addr, size_t length)
{
	doLog(MUNMAP, addr, length);

#if !defined(TEST_REPL)
	return munmap(addr, length);
#else
	return 1;
#endif
}

int repl_brk(void *addr)
{
	doLog(BRK, addr, 0);

#if !defined(TEST_REPL)
	return brk(addr);
#else
	return 1;
#endif
}

void *repl_sbrk(intptr_t incr)
{
#if !defined(TEST_REPL)
	void *ptr = sbrk(incr);
#else
	void *ptr = NULL;
#endif
	doLog(SBRK, ptr, incr);
	return ptr;
}