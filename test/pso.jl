# test particle initialization
limits = [[0:10:100] [10:10:110]]
p = Particle(limits)
@assert(limits[:,1] < p.position < limits[:,2])
@assert(p.p_position == p.position)
@assert(p.l_position == p.position)
