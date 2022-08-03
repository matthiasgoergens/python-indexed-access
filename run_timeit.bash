#!/usr/bin/bash
python -m timeit \
    --setup "import chris_barker_benchmark as b" \
    --unit usec \
    "b.sample_list(b.DICT)"
