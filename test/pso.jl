println(" * Run a pso, make sure the solution is within specified limits")
limits = [[0:10:100] [10:10:110]]
best = pso(limits, sum)
@assert(best >= limits[:, 1])
@assert(best <= limits[:, 2])

println(" * Run an arbitrary function")
function rosenbrock(x::Vector)
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

limits = [[0, 0] [2, 2]]
best = pso(limits, rosenbrock)
@assert(best >= limits[:, 1])
@assert(best <= limits[:, 2])

println(" * Run with no limits, check solution")
best = pso(2, rosenbrock, 100)
solution = [[-10, -10] [10, 10]]
@assert(best >= solution[:, 1])
@assert(best <= solution[:, 2])
