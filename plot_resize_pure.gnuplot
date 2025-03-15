# set term svg enhanced mouse size 1000,1000
# set output 'plot_holes.svg'

set term png size 2000,2000
set output 'output_pure.png'

plot \
    'output_holes_amortised_with_resize_3/benchmark.data' using ($1-$2):4 ps 0.2, \
    'output_pure/benchmark.data' using ($1-$2):4 ps 0.2
    


# set output 'output_holes_amortised_with_resize_3.png'
# plot \
#     'output_holes_amortised_with_resize_3/benchmark.data' using ($1-$2):3 ps 0.2
# #    holes(x)

    #  f(x) = a*x**2 + b*x + c
    #  g(x,y) = a*x**2 + b*y**2 + c*x*y
    #  FIT_LIMIT = 1e-6
    #  fit f(x) 'measured.dat' via 'start.par'
    #  fit f(x) 'measured.dat' using 3:($7-5) via 'start.par'
    #  fit f(x) './data/trash.dat' using 1:2:3 via a, b, c
    #  fit g(x,y) 'surface.dat' using 1:2:3:(1) via a, b, c

