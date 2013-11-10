# ga.jl - A genetic algorithm
#
# This julia implementation is part of alji:
#  https://github.com/d9w/alji
#
# Copyright Dennis Wilson 2013, under the GPL (see alji for version)

type Individual
  genome::Vector{Chromosome}
  fitness::Float64
end

function Individual(genome::Vector{Chromosome})
  # new random individual based on genome
  new_genome = []
  for chrom in genome
    new_genome = [new_genome, Chromosome(chrom.markers)]
  end
  Individual(new_genome, 0.0)
end

function mutate(ind::Individual)
  for chrom in ind.genome
    mutate(chrom)
  end
end

function cross(ind1::Individual, ind2::Individual)
  child1_genome = []
  child2_genome = []
  for i=1:min(length(ind1.genome),length(ind2.genome))
    (chrom1, chrom2) = cross(ind1.genome[i],ind2.genome[i])
    child1_genome = [child1_genome, chrom1]
    child2_genome = [child2_genome, chrom2]
  end
  (Individual(child1_genome, 0.0), Individual(child2_genome, 0.0))
end

function select(pop::Vector{Individual}, N::Int64)
  # stochastic universal sampling
  F = sum([ind.fitness for ind in pop])
  points = F/N * (rand() + 0:N)
  i = 1
  total_fitness = pop[1].fitness
  selection = []
  for p in points
    while total_fitness < p
      i+=1
      total_fitness += pop[i].fitness
    end
    selection = [pop[i], selection]
    if i < length(pop)
      i+=1
      total_fitness += pop[i].fitness
    end
  end
  selection
end

function select(pop::Vector{Individual}, N::Int64, T::Int64)
  # tournament selection
  selection = []
  pop = pop[randperm(length(pop))]
  if (N * T) > length(pop) # don't choose bad T
    T = floor(length(pop)/N)
  end
  winner_fit = -1
  for i=1:(N*T)
    if i % T == 1
      winner_fit = -1
    end
    if pop[i].fitness > winner_fit
      winner = pop[i]
      winner_fit = winner.fitness
    end
    if i % T == 0
      selection = [winner, selection]
    end
  end
  selection
end

function ga(genome::Vector{Chromosome}, fitness::Function,
                                        P::Int64=200, N::Int64=20, T::Int64=3)
  # main ga

  # make initial population

end
