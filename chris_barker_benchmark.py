import random
from itertools import islice

DICT = {str(i): i for i in range(100000)}

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
    return next(islice(DICT.items(), n, n + 1))
