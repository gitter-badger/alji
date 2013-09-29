# This PSO is based on the 2011 Standard: the next position of each particle is
# chosen as a velocity offset of a random point in hypersphere. A good
# explanation of the standard is here:
#  http://clerc.maurice.free.fr/pso/SPSO_descriptions.pdf
#
# This julia implementation is part of alji:
#  https://github.com/d9w/alji
#
# Copyright Dennis Wilson 2013, under the GPL (see alji for version)

const N_PARTICLES = 40
const K = 3 # suggested neighborhood size

type Particle{T}
  position::Vector{T} # current position
  fitness::Float64
  p_position::Vector{T} # previous best position
  p_fitness::Float64
  l_postion::Vector{T} # local best position
  l_fitness::Float64
  velocity::Vector{T}
  neighbors::Vector{T}
end

function Particle{T}(limits::Array{T})
  # let limits be an dim*2 matrix, with [mins maxs]
  dim = size(limits, 1)
  position = limits[:,1] + rand(dim) .* (limits[:,2] - limits[:,1])
  velocity = limits[:,1] - position + rand(dim) .* (limits[:,2] - limits[:,1])
  fitness::Float64 = 0.0
  neighbors = round(rand(K) * (N_PARTICLES - 1) + 0.5)
  Particle{Float64}(position, fitness, position, fitness, position, fitness,
                              velocity, neighbors)
end

limits = [[0:10:100] [10:10:110]]
p = Particle(limits)
print(p)
