println("  * Create an individual")
genome = [Chromosome(i) for i in rand(10:20,6)]
ind = Individual(genome)
@assert(ind.genome != genome)
[@assert(ind.genome[i].markers == genome[i].markers) for i=1:length(genome)]
@assert(ind.fitness == 0.0)

println("   * Stochastic universal sampling")
genome = [Chromosome(i) for i in rand(10:20,6)]
pop = [Individual(genome) for i=1:10]
[ind.fitness = rand() for ind in pop]
selection = select(pop, 4)
@assert(length(selection) == 4)
[@assert(ind in pop) for ind in selection]

println("   * Tournament selection")
genome = [Chromosome(i) for i in rand(10:20,10)]
pop = [Individual(genome) for i=1:10]
[ind.fitness = rand() for ind in pop]
selection = select(pop, 3, 3)
@assert(length(selection) == 3)
[@assert(ind in pop) for ind in selection]
