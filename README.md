alji
====

Artificial Life: a Julia Implementation

I research artificial life and recently became infatuated with
[julia](http://julialang.org/). This is the where I'll be playing around with
different artificial life, hopefully covering the popular ones like PSO,
CMA-ES, GA, GRN, NEAT. Hm, a space-man sent grog. Strange.

PSO
---
pso.jl is based on the 2011 Standard PSO, a good description of which can be
found [here](http://clerc.maurice.free.fr/pso/SPSO_descriptions.pdf). A random
point between the previous best, the local global best, and the current
particle position in an n-sphere is chosen for the position and velocity
updates. Particles communicate in a random network that changes after each
non-advancing iteration. The particles are bound and will rebound off the edges
of the search space. This pso is minimizing; it looks for the lowest possible
solution.

The pso is exported as a function and is called like
```julia
using Alji
best = pso(limits, function, itermax, n_particles, K)
```
Arguments are:
* limits: an nx2 array of bounds for each dimension n
* function: the evaluation function, which should take in a Vector{Float64} and
  return a Float64
* *itermax*: (optional) the number of iterations, default 100
* *n_particles*: (optional) the number of particles, default 40
* *K*: (optional) the neighborhood size for communication, default 3
The function returns `best`, an n-dimensional Vector{Float64} of the best position.

So the following:
```julia
using Alji
best = pso([zeros(10), ones(10)], sum, 1000)
```
would search for the smallest sum of 10 floats between zero and one, and would
run for 1000 iterations with 40 particles and 3 particles per neighbor.
