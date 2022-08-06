import random
from itertools import islice

DICT = {str(i): i for i in range(100_000)}

def sample_list(d):
    return random.choice(list(d.items()))


def sample_iter(d):
    n = random.randint(1, len(d)-1)
    items = iter(d.items())
    for i in range(n):
        val = next(items)
    return val


def sample_iter2(d):
    n = random.randint(0, len(d)-1)
    for i, val in enumerate(d.items()):
        if i == n:
            break
    return val



def sample_islice(d):
    n = random.randint(0, len(d)-1)
    return next(islice(d.items(), n, n + 1))

from hypothesis import given, settings, strategies as st, example

@example(size=610976)
@example(size=110681)
# @given(size=st.integers(min_value=1, max_value=100_000))
@given(size=st.integers(min_value=1, max_value=110_681))
def test_sample_islice(size):
    d = {str(i): i for i in range(size)}
    sample_islice(d)


import index_access as ia
import time

"""
In [45]: %timeit sample_list(DICT)
5.75 ms ± 72.1 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

In [46]: %timeit sample_iter(DICT)
3.65 ms ± 151 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

In [47]: %timeit sample_iter2(DICT)
3.1 ms ± 212 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

In [48]: %timeit sample_islice(DICT)
507 µs ± 19.7 µs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)
"""

import timeit
import subprocess
import shlex

def run1(what):
    cmd = shlex.split("""python -m timeit --setup "import chris_barker_benchmark as b" --unit msec""")
    subprocess.run(cmd + [what])

import random
from pathlib import Path

def benchmark():
    Path('output').mkdir(exist_ok=True)
    funs = [sample_list, sample_iter, sample_iter2, sample_islice, ia.sample]
    while True:
        size = random.randrange(1, 1_000_000)
        d = {str(i): i for i in range(size)}
        f = random.choice(funs)
        start = time.perf_counter()
        f(d)
        stop = time.perf_counter()
        Path('output', f.__name__).open(mode='at').write(f"{size} {stop-start}\n")


def benchmark_holes():
    output_dir = Path('output_holes')
    output_dir.mkdir(exist_ok=True)
    start_size = 100_000
    with (output_dir / 'benchmark.data').open(mode='at') as f:
        while True:
            d = {str(i): i for i in range(start_size)}
            while d:
                start = time.perf_counter()
                (slot, key, value) = ia.sample(d)
                stop = time.perf_counter()
                f.write(f"{len(d)} {stop-start}\n")
                del d[key]

def benchmark_holes_amortised():
    output_dir = Path('output_holes_amortised')
    output_dir.mkdir(exist_ok=True)
    start_size = 100_000
    with (output_dir / 'benchmark.data').open(mode='at') as f:
        while True:
            d = {str(i): i for i in range(start_size)}
            start = time.perf_counter()
            while d:
                (slot, key, value) = ia.sample(d)
                stop = time.perf_counter()
                del d[key]
                f.write(f"{start_size} {len(d)} {stop-start}\n")


def main():
    to_run = [
    'b.sample_list(b.DICT)',
    'b.sample_iter(b.DICT)',
    'b.sample_iter2(b.DICT)',
    'b.sample_islice(b.DICT)',
    'b.ia.sample(b.DICT)']
    for what in to_run:
        print(f"Executing {what}")
        run1(what)
        print()

"""
Idea: explain our runtime with regards to the https://en.wikipedia.org/wiki/Coupon_collector%27s_problem and do benchmarks with it.

(Basically, that's how we do amortised analysis.)

In addition, use a loop of
  o = object()
  d[o] = o
  del o
to force a resize, when we are getting too sparse.
"""

if __name__ == '__main__':
    test_sample_islice()

    # benchmark_holes()
    benchmark_holes_amortised()
    # main()
