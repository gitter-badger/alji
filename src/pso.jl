# This PSO is based on the 2011 Standard: the next position of each particle is
# chosen as a velocity offset of a random point in hypersphere. A good
# explanation of the standard is here:
#  http://clerc.maurice.free.fr/pso/SPSO_descriptions.pdf
#
# This julia implementation is part of alji:
#  https://github.com/d9w/alji
#
# Copyright Dennis Wilson 2013, under the GPL (see alji for version)

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

function update(particle::Particle, limits)
  # temporary, will be expanded later
  particle.position = limits[:,1] + rand(size(limits, 1)) .* (limits[:,2] - limits[:,1])
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

function pso(limits, fitness::Function, itermax = 100, n_particles = 40, K = 3)

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

    println([iter "\t" best_particle.p_fitness])

  end
  best_particle.p_position
end
