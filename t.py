import random

def _randbelow_with_getrandbits(n):
    "Return a random int in the range [0,n).  Defined for n > 0."

    getrandbits = random.getrandbits
    k = (n-1).bit_length()
    r = getrandbits(k)  # 0 <= r < 2**k
    print(f"r: {r}")
    while r >= n:
        r = getrandbits(k)
        print(f"    r: {r}")
    return r

def _randbelow_with_getrandbits(n):
    "Return a random int in the range [0,n).  Defined for n > 0."

    while (r:=random.getrandbits((n-1).bit_length())) >= n:
        pass
        print(f"    r: {r}")
    print(f"r: {r}")
    return r

def main():
    _randbelow_with_getrandbits(8)

if __name__ == '__main__':
    main()
