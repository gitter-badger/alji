# test particle initialization
limits = [[0:10:100] [10:10:110]]
best = pso(limits, sum)
for i=1:size(limits,1)
  @assert(best[i] > limits[i, 1])
  @assert(best[i] < limits[i, 2])
end
