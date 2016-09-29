alji
====

[![Join the chat at https://gitter.im/d9w/ALJI.jl](https://badges.gitter.im/d9w/ALJI.jl.svg)](https://gitter.im/d9w/ALJI.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Artificial Life: a Julia Implementation

Somewhere betweeen a module and a collection of tools, but mostly a work in progress and experiment.

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

GA
---
ga.jl is a standard genetic algorithm, using the Chromosome class from
chromosome.jl, which are bit arrays with region markers. Methods to work with
Gray codes are provided in gray.jl. The GA uses tournament selection, though
stochastic universal sampling is also implemented. Elitism is used to pass the
best subpopulation on each iteration.
