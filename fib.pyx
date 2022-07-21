#cython: language_level=3

import cython
from typing import Any
# import PyDict
from cpython.dict cimport PyDict_Next, PyDict_Size
from cpython.ref cimport PyObject
from random import randrange

cdef linear_nentries(d):
    # Get the dicts dk_nentries

    cdef PyObject *key
    cdef PyObject *value
    cdef Py_ssize_t pos = 0

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
    return pos

# Binary search for size of the dict.
cdef nentries(d):
    cdef PyObject *key = NULL
    cdef PyObject *value = NULL
    cdef Py_ssize_t pos = 0
    cdef Py_ssize_t lower, upper

    cdef Py_ssize_t guess = PyDict_Size(d)
    pos = guess
    if not PyDict_Next(d, &pos, &key, &value):
        return guess
    else:
        # Now invariant is that lower works.
        lower = guess
        upper = 2 * lower
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
        # print(f"upper: {upper}")
        return upper

cdef sample(d):
    n = nentries(d)
    cdef PyObject *key = NULL
    cdef PyObject *value = NULL
    cdef Py_ssize_t pos
    while True:
        x = randrange(n)
        pos = x
        if PyDict_Next(d, &pos, &key, &value) and x + 1 == pos:
            return (x, <object> key, <object> value)

def t():
    nentries({'a':'x', 'b': 'y', 'c': 'z'})
    d = {i*10+1: str(i) for i in range(10_001)}
    for i in range(1_000, 8_000):
        d.pop(i*10+1)
    print(f"nentries: {nentries(d)}")
    # print(len(d))
    g = nentries({})
    print(f"nentries: {g}")
    samples = sorted([sample(d) for _ in range(10)])
    # Below, we try to trigger a resizing.
    print(f"Sample: {samples}")
    for _ in range(1_000):
        d['foo'] = 'bar'
        d.pop('foo')
    samples = sorted([sample(d) for _ in range(10)])
    print(f"Sample: {samples}")
    print(f"nentries: {nentries(d)}")
    

def fib(n):
    """Print the Fibonacci series up to n."""
    a, b = 0, 1
    while b < n:
        print(b, end=' ')
        a, b = b, a + b

    print()
