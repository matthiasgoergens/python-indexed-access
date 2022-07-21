#cython: language_level=3

import cython
from typing import Any
# import PyDict
from cpython.dict cimport PyDict_Next, PyDict_Size
from cpython.ref cimport PyObject

# Binary search for size of the dict.
cdef nentries(d):
    # Get the dicts dk_nentries

    cdef PyObject *key
    cdef PyObject *value
    cdef Py_ssize_t pos = 0

    # d.next(pos, key, value)
    cdef PyObject v

    while PyDict_Next(d, &pos, &key, &value):
        # print(pos, end='\t')
        v = value[0]
        # v = value[0][0]
        # print(v, end='\t')
        # print(v)
    print()
    # real_nentries now is the last entry plus one extra.
    real_nentries = pos
    print(f"linear real_nentries: {real_nentries}")

    # We want to find the first entry that's where PyDict_Next returns 0.  For 
    # an empty dict, that's 0
    cdef Py_ssize_t guess = PyDict_Size(d) # What about empty?
    print(f"guess = len: {guess}")
    # cdef Py_ssize_t upper = 2 * lower
    # At this point in time, our guesses are unverified.
    pos = guess
    if not PyDict_Next(d, &pos, &key, &value):
        return guess
    else:
        # Now lower is verified.
        lower = guess
        upper = 2 * guess
        pos = upper
        while PyDict_Next(d, &pos, &key, &value):
            lower = upper
            upper = 2 * upper
            pos = upper
        # Now lower is verified to work, and upper is verified to not work.
        # Just binary search then.
        while lower + 1 < upper:
            mid = (lower + upper) // 2
            pos = mid
            if PyDict_Next(d, &pos, &key, &value):
                lower = mid
            else:
                upper = mid
        print(f"upper: {upper}")
        return upper

def t():
    # it({'a':'x', 'b': 'y', 'c': 'z'})
    d = {i*10: str(i) for i in range(10_001)}
    for i in range(1, 5):
        d.pop(i*10)
    nentries(d)
    # print(len(d))
    g = nentries({})
    print(f"nentries: {g}")

def fib(n):
    """Print the Fibonacci series up to n."""
    a, b = 0, 1
    while b < n:
        print(b, end=' ')
        a, b = b, a + b

    print()
