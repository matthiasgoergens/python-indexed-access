#cython: language_level=3

import cython
from typing import Any
# import PyDict
from cpython.dict cimport PyDict_Next, PyDict_Size
from cpython.ref cimport PyObject
from random import randrange

cdef linear_nentries(d):
    """Get the number of dict entries (dk_nentries) via a linear scan"""

    cdef PyObject *key
    cdef PyObject *value
    cdef Py_ssize_t pos = 0

    while PyDict_Next(d, &pos, &key, &value):
        pass
    return pos

cdef nentries(d):
    """Get the number of dict entries (dk_nentries) via binary search"""
    cdef PyObject *key = NULL
    cdef PyObject *value = NULL
    cdef Py_ssize_t pos = 0
    cdef Py_ssize_t lower, upper

    # Number of entries must be at least `len(d)`
    cdef Py_ssize_t guess = PyDict_Size(d)
    pos = guess
    if not PyDict_Next(d, &pos, &key, &value):
        return guess
    else:
        lower = guess
        # From now on, `lower` will always be a valid entry.
        upper = 2 * lower
        pos = upper
        while PyDict_Next(d, &pos, &key, &value):
            lower = upper
            upper = 2 * upper
            pos = upper
        # From now on, upper will always stay an invalid entry.
        # dk_nentries is the first invalid entry.
        # So let's do binary search:
        while lower + 1 < upper:
            mid = (lower + upper) // 2
            pos = mid
            if PyDict_Next(d, &pos, &key, &value):
                lower = mid
            else:
                upper = mid
        return upper

def sample(d):
    """Random sampling in a dict"""
    n = nentries(d)
    cdef PyObject *key = NULL
    cdef PyObject *value = NULL
    cdef Py_ssize_t pos
    while True:
        x = randrange(n)
        pos = x
        if PyDict_Next(d, &pos, &key, &value) and x + 1 == pos:
            return (x, <object> key, <object> value)


def entries(d):
    return nentries(d)

def test_run():
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
