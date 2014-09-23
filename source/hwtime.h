/*
** This file contains inline asm code for retrieving "high-performance"
** counters for x86 class CPUs.
*/
#ifndef _HWTIME_H_
#define _HWTIME_H_

/*
** The following routine only works on pentium-class (or newer) processors.
** It uses the RDTSC opcode to read the cycle count value out of the
** processor and returns that value.  This can be used for high-res
** profiling.
*/
__inline__ uint64_t hwtime(void){
    unsigned long val;
    __asm__ __volatile__ ("rdtsc" : "=A" (val));
    return val;
}

#endif