// -*- C++ -*-

#ifndef HL_TRACKHEAP_H
#define HL_TRACKHEAP_H

#include <stdio.h>
#include <stdlib.h>
#include <list>
#include "heaplayers.h"

namespace HL {
	template<class SuperHeap>
	class TrackHeap : public SuperHeap {
		inline uint64_t hwtime(){
			unsigned int lo, hi;
			__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
			return (uint64_t)hi << 32 | lo;
		}

	public:
		inline void * malloc (size_t sz, std::list<uint64_t> *log){
			void * addr = SuperHeap::malloc (sz);
			log->push_back (hwtime());
			return addr;
		}

		inline void free (void * ptr, std::list<uint64_t> *log) {
			log->push_back (hwtime());
			SuperHeap::free (ptr);
		}
	};
}
#endif