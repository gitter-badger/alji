# This PSO is based on the 2011 Standard: the next position of each particle is
# chosen as a velocity offset of a random point in hypersphere. A good
# explanation of the standard is here:
#  http://clerc.maurice.free.fr/pso/SPSO_descriptions.pdf
#
# This julia implementation is part of alji:
#  https://github.com/d9w/alji
#
# Copyright Dennis Wilson 2013, under the GPL (see alji for version)

const w = 1/(2log(2))
const c = 1/2 + log(2)

type Particle
  position::Vector{Float64} # current position
  fitness::Float64
  p_position::Vector{Float64} # previous best position
  p_fitness::Float64
  l_position::Vector{Float64} # local best position
  l_fitness::Float64
  velocity::Vector{Float64}
end

function Particle(limits)
  # limits must be an dim*2 matrix, with [mins maxs]
  dim = size(limits, 1)
  position = limits[:,1] + rand(dim) .* (limits[:,2] - limits[:,1])
  velocity = limits[:,1] - position + rand(dim) .* (limits[:,2] - limits[:,1])
  fitness = Inf
  Particle(position, fitness, position, fitness, position, fitness, velocity)
end

function update(p::Particle, limits)

  # set gravity point
  if p.p_position == p.l_position
    G = p.position + c * (p.p_position - p.position)/2
  else
    G = p.position + c * (p.p_position + p.l_position - 2p.position)/3
  end

  # normally distributed random point in the hypersphere
  radius = abs(G - p.position)
  x = G + randn(length(p.position)) .* radius

  # next timestep velocity and position
  wvel = w * p.velocity
  p.velocity = wvel + x - p.position
  p.position = wvel + x

  # enforce boundaries
  p.velocity[p.position.<limits[:,1]] = -0.5 * p.velocity[p.position.<limits[:,1]]
  p.velocity[p.position.>limits[:,2]] = -0.5 * p.velocity[p.position.>limits[:,2]]
  p.position[p.position.<limits[:,1]] = limits[p.position.<limits[:,1], 1]
  p.position[p.position.>limits[:,2]] = limits[p.position.>limits[:,2], 2]

end

function update(network::BitArray, K)
  network = falses(size(network))
  # update neighbors
  for i=1:size(network,1)
    for j=1:K
      network[i, round(rand()*(size(network,2)-1))+1] = true
    end
  end
  # self is always a neighbor
  network[1:size(network,1)+1:*(size(network)...)] = true # diagonal
end

function evaluate(particle::Particle, fitness::Function)
  particle.fitness = fitness(particle.position)
  if particle.fitness < particle.p_fitness
    particle.p_fitness = particle.fitness
    particle.p_position = particle.position
  end
end

function pso(limits::Array, fitness::Function, itermax = 100, n_particles = 40, K = 3)

  particles = [Particle(limits) for i=1:n_particles]
  best_particle = particles[1]
  network = falses(n_particles, n_particles)
  update(network, K)

  for iter = 1:itermax
    iter_best = best_particle

    # update position
    if iter > 1
      for particle in particles
        update(particle, limits)
      end
    end

    # evaluate fitness
    for particle in particles
      evaluate(particle, fitness)
      if particle.p_fitness < iter_best.p_fitness
        iter_best = particle
      end
    end

    # set local best
    for i = 1:length(particles)
      neighbors = particles[network[:,i]]
      for neighbor in neighbors
        if neighbor.p_fitness < particles[i].l_fitness
          particles[i].l_fitness = neighbor.p_fitness
          particles[i].l_position = neighbor.p_position
        end
      end
    end

    # new best or new network graph
    if iter_best.p_fitness < best_particle.p_fitness
      best_particle = iter_best
    else
      update(network, K)
    end

    print([iter "\t" best_particle.p_fitness])

  end
  best_particle.p_position
end

function pso(n::Real, fitness::Function, itermax = 100, n_particles = 40, K = 3)
  limits = [[realmin(Float64) for i=1:n] [realmax(Float64) for i=1:n]]
  pso(limits, fitness, itermax, n_particles, K)
end
