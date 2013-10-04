using Gadfly

println("   * Run a pso, make sure the solution is within specified limits")
limits = [[0:10:100] [10:10:110]]
best = pso(limits, sum)
@assert(best >= limits[:, 1])
@assert(best <= limits[:, 2])

println("   * Run an arbitrary function")
function rosenbrock(x::Vector)
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

limits = [[0, 0] [2, 2]]
best = pso(limits, rosenbrock)
@assert(best >= limits[:, 1])
@assert(best <= limits[:, 2])

println("   * Run multiple times, check for accuracy")
limits = [[-10, -10] [10, 10]]
avgs = zeros(100)
for j=1:100
  avg_fit = 0.0
  for i=1:30
    best = pso(limits, rosenbrock, j)
    avg_fit += rosenbrock(best)
  end
  avgs[j] = avg_fit/30.0
end
draw(SVG("2006pso.svg", 6inch, 3inch),
      plot(x=collect(1:100), y=avgs,
                             Guide.XLabel("Step"), Guide.YLabel("Avg fit"))
@assert(avg_fit >= -0.1)
@assert(avg_fit <= 0.1)
