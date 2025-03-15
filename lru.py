"""
We want to implement an LRU cache that only uses a single Python dict,
and no auxiliary datastructure like a queue.

We want to re-use the machinery that keeps dicts ordered, to replace the queue.

We will need to (ab)use PyDict_Next.

But we need to worry about resizing the dict mucking around with our iteration.

Simple fix: don't delete, just mark as deleted?

Also: goal is to be faster than LRU cache.

Benchmarks: large cache with random access?  Also try smaller caches, and non-random access.

LRU cache from the standard library is threadsafe.  It uses locks.  But perhaps
we don't need locks, beyond the GIL we already get.

Note there's a pure Python lru cache implementation in the standard library and
an optimized C version.  The optimized C version already only uses the GIL.  So
it's definitely possible.

The C version lives in 'Modules/_functoolsmodule.c'.

The C version uses the 'known hash' versions for dict calls, those are only
available for internal clients, and not part of the public C API.

So far a proper comparison, we could do that, too.
"""
