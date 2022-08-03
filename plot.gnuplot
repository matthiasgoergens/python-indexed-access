set term svg enhanced mouse size 1000,1000
set output 'plot.svg'

sample(x) = a0*x + b0
sample_list(x)=a1*x + b1
sample_iter(x)=a2*x + b2
sample_iter2(x)=a3*x + b3
sample_islice(x)=a4*x + b4

fit sample(x) 'output/sample' using 1:2 via a0,b0
fit sample_list(x) 'output/sample_list' using 1:2 via a1,b1
fit sample_iter(x) 'output/sample_iter' using 1:2 via a2,b2
fit sample_iter2(x) 'output/sample_iter2' using 1:2 via a3,b3
fit sample_islice(x) 'output/sample_islice' using 1:2 via a4,b4

plot \
    'output/sample' ps 0.2, \
    sample(x), \
    'output/sample_list' ps 0.2, \
    sample_list(x), \
    'output/sample_iter' ps 0.2, \
    sample_iter(x), \
    'output/sample_iter2' ps 0.2, \
    sample_iter2(x), \
    'output/sample_islice' ps 0.2, \
    sample_islice(x)

    #  f(x) = a*x**2 + b*x + c
    #  g(x,y) = a*x**2 + b*y**2 + c*x*y
    #  FIT_LIMIT = 1e-6
    #  fit f(x) 'measured.dat' via 'start.par'
    #  fit f(x) 'measured.dat' using 3:($7-5) via 'start.par'
    #  fit f(x) './data/trash.dat' using 1:2:3 via a, b, c
    #  fit g(x,y) 'surface.dat' using 1:2:3:(1) via a, b, c

