/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef replace_malloc_h
#define replace_malloc_h

/*
 * The replace_malloc facility allows an external library to replace or
 * supplement the jemalloc implementation.
 *
 * The external library may be hooked by setting one of the following
 * environment variables to the library path:
 *   - LD_PRELOAD on Linux,
 *   - DYLD_INSERT_LIBRARIES on OSX,
 *   - MOZ_REPLACE_MALLOC_LIB on Windows and Android.
 *
 * An initialization function is called before any malloc replacement
 * function, and has the following declaration:
 *
 *   void replace_init(const malloc_table_t *)
 *
 * The const malloc_table_t pointer given to that function is a table
 * containing pointers to the original jemalloc implementation, so that
 * replacement functions can call them back if they need to. The pointer
 * itself can safely be kept around (no need to copy the table itself).
 *
 * The functions to be implemented in the external library are of the form:
 *
 *   void *replace_malloc(size_t size)
 *   {
 *     // Fiddle with the size if necessary.
 *     // orig->malloc doesn't have to be called if the external library
 *     // provides its own allocator, but in this case it will have to
 *     // implement all functions.
 *     void *ptr = orig->malloc(size);
 *     // Do whatever you want with the ptr.
 *     return ptr;
 *   }
 *
 * where "orig" is the pointer obtained from replace_init.
 *
 * See malloc_decls.h for a list of functions that can be replaced this
 * way. The implementations are all in the form:
 *   return_type replace_name(arguments [,...])
 *
 * They don't all need to be provided.
 *
 * Building a replace-malloc library is like rocket science. It can end up
 * with things blowing up, especially when trying to use complex types, and
 * even more especially when these types come from XPCOM or other parts of the
 * Mozilla codebase.
 * It is recommended to add the following to a replace-malloc implementation's
 * Makefile.in:
 *   MOZ_GLUE_LDFLAGS = # Don't link against mozglue
 *   WRAP_LDFLAGS = # Never wrap malloc function calls with -Wl,--wrap
 * and the following to the implementation's moz.build:
 *   DISABLE_STL_WRAPPING = True # Avoid STL wrapping
 *
 * If your replace-malloc implementation lives under memory/replace, these
 * are taken care of by memory/replace/defs.mk.
 */

/* Implementing a replace-malloc library is incompatible with using mozalloc. */
#define MOZ_NO_MOZALLOC 1

#ifndef _JEMALLOC_TYPES_H_
#define _JEMALLOC_TYPES_H_

	/* grab size_t */
	#include <stddef.h>

	#ifdef __cplusplus
	extern "C" {
	#endif

	typedef unsigned char jemalloc_bool;

	/*
	 * jemalloc_stats() is not a stable interface.  When using jemalloc_stats_t, be
	 * sure that the compiled results of jemalloc.c are in sync with this header
	 * file.
	 */
	typedef struct {
		/*
		 * Run-time configuration settings.
		 */
		jemalloc_bool	opt_abort;	/* abort(3) on error? */
		jemalloc_bool	opt_junk;	/* Fill allocated memory with 0xa5/0x5a? */
		jemalloc_bool	opt_poison;	/* Fill free memory with 0xa5/0x5a? */
		jemalloc_bool	opt_utrace;	/* Trace all allocation events? */
		jemalloc_bool	opt_sysv;	/* SysV semantics? */
		jemalloc_bool	opt_xmalloc;	/* abort(3) on OOM? */
		jemalloc_bool	opt_zero;	/* Fill allocated memory with 0x0? */
		size_t	narenas;	/* Number of arenas. */
		size_t	balance_threshold; /* Arena contention rebalance threshold. */
		size_t	quantum;	/* Allocation quantum. */
		size_t	small_max;	/* Max quantum-spaced allocation size. */
		size_t	large_max;	/* Max sub-chunksize allocation size. */
		size_t	chunksize;	/* Size of each virtual memory mapping. */
		size_t	dirty_max;	/* Max dirty pages per arena. */

		/*
		 * Current memory usage statistics.
		 */
		size_t	mapped;		/* Bytes mapped (not necessarily committed). */
		size_t	allocated;	/* Bytes allocated (committed, in use by application). */
	        size_t  waste;          /* Bytes committed, not in use by the
	                                   application, and not intentionally left
	                                   unused (i.e., not dirty). */
	        size_t	page_cache;	/* Committed, unused pages kept around as a
	                                   cache.  (jemalloc calls these "dirty".) */
	        size_t  bookkeeping;    /* Committed bytes used internally by the
	                                   allocator. */
		size_t bin_unused; /* Bytes committed to a bin but currently unused. */
	} jemalloc_stats_t;

	#ifdef __cplusplus
	} /* extern "C" */
	#endif

#endif /* _JEMALLOC_TYPES_H_ */

#if defined(__GNUC__) && defined(__cplusplus) && !defined(__GXX_EXPERIMENTAL_CXX0X__) && __cplusplus < 201103L
	#define decltype __typeof__
#endif

#define MOZ_EXPORT __attribute__((visibility("default")))

#ifdef __cplusplus
  #define MOZ_BEGIN_EXTERN_C    extern "C" {
  #define MOZ_END_EXTERN_C      }
#else
  #define MOZ_BEGIN_EXTERN_C
  #define MOZ_END_EXTERN_C
#endif

MOZ_BEGIN_EXTERN_C

#define MALLOC_DECL(name, return_type, ...) \
  typedef return_type(name ## _impl_t)(__VA_ARGS__);

#include "malloc_decls.h"

#define MALLOC_DECL(name, return_type, ...) \
  name ## _impl_t * name;

typedef struct {
#include "malloc_decls.h"
} malloc_table_t;

MOZ_EXPORT void replace_init(const malloc_table_t *table)
{
	write(1, "replace_init\n", 13);
}

MOZ_END_EXTERN_C

#endif /* replace_malloc_h */