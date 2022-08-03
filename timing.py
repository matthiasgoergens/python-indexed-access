import index_access as ia

def test_run():
    ia.entries({'a':'x', 'b': 'y', 'c': 'z'})
    d = {i*10+1: str(i) for i in range(10_001)}
    for i in range(1_000, 8_000):
        d.pop(i*10+1)
    print(f"nentries: {ia.entries(d)}")
    # print(len(d))
    g = ia.entries({})
    print(f"nentries: {g}")
    samples = sorted([ia.sample(d) for _ in range(10)])
    # Below, we try to trigger a resizing.
    print(f"Sample: {samples}")
    for _ in range(1_000):
        d['foo'] = 'bar'
        d.pop('foo')
    samples = sorted([ia.sample(d) for _ in range(10)])
    print(f"Sample: {samples}")
    print(f"nentries: {ia.entries(d)}")

if __name__ == '__main__':
    test_run()
